extends CharacterBody2D

const DUST = preload("res://scenes/dust.tscn")
const ENEMY_ARROW = preload("res://scenes/enemy_arrow.tscn")
const SHOOT_START = preload("res://assets/audios/shoot_start.ogg")

@onready var arena: Node2D = get_tree().get_root().get_node("Arena")
@onready var audio_manager: Node2D = arena.get_node("Map/AudioManager")
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("players")
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var shoot_animation_player: AnimationPlayer = $ShootAnimationPlayer
@onready var hurtbox: Area2D = $Hurtbox
@onready var hurtbox_collision_shape_2d: CollisionShape2D = $Hurtbox/CollisionShape2D
@onready var action_timer: Timer = $ActionTimer
@onready var shoot_timer: Timer = $ShootTimer

var is_flipped = false
var is_moving = false
var is_reaching = false
var is_attacking = false
var can_move = true
var can_attack = true
var shoot_position = null
var move_speed = 200
var shoot_speed = 800
var idle_time = 4
var move_time = 4
var shoot_time = 1
var shoot_damage = 1
var maximum_health = 1
var current_health = maximum_health

func _physics_process(_delta: float) -> void:
	
	if player.is_dead:
		animated_sprite_2d.play("shoot" if is_attacking else "idle")
		return
	
	if !is_attacking:
		if can_attack and hurtbox.overlaps_body(player):
			is_attacking = true
			is_moving = false
			shoot_position = player.global_position
			shoot_animation_player.play("shoot")
			audio_manager.play_audio(SHOOT_START, global_position)
		elif can_move and !is_moving:
			is_moving = true
			action_timer.start(randf_range(move_time * 0.5, move_time))
		elif !can_move and is_moving:
			is_moving = false
			action_timer.start(randf_range(idle_time * 0.5, idle_time))

	var move_direction = global_position.direction_to(player.global_position)
	velocity = move_speed * move_direction if is_moving else Vector2.ZERO
	move_and_slide()
	
	animated_sprite_2d.play("shoot" if is_attacking else "move" if velocity.length() > 0 else "idle")
	if move_direction.x > 0 == is_flipped and !is_attacking:
		is_flipped = !is_flipped
		animated_sprite_2d.flip_h = is_flipped
		hurtbox_collision_shape_2d.position.x = -hurtbox_collision_shape_2d.position.x
		
func _on_shoot_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "shoot":
		is_attacking = false
		is_moving = true
		can_move = false
		can_attack = false
		shoot_position = null
		shoot_timer.start(shoot_time)
		
func _on_action_timer_timeout() -> void:
	can_move = !can_move
	
func _on_shoot_timer_timeout() -> void:
	can_attack = true

func take_damage(damage: int) -> int:
	current_health = max(0, current_health - damage)
	if current_health == 0:
		var dust_instance = DUST.instantiate()
		dust_instance.global_position = global_position
		arena.add_child(dust_instance)
		ScoreManager.increase_score()
		queue_free()
	return current_health

func shoot() -> void:
	var shoot_direction = global_position.direction_to(shoot_position)
	var enemy_arrow_instance = ENEMY_ARROW.instantiate()
	enemy_arrow_instance.global_position = global_position
	enemy_arrow_instance.look_at(shoot_position)
	enemy_arrow_instance.apply_impulse(shoot_speed * shoot_direction)
	enemy_arrow_instance.contact_damage = shoot_damage
	arena.add_child(enemy_arrow_instance)
