extends CharacterBody2D

const DUST = preload("res://scenes/dust.tscn")
const ATTACK_START = preload("res://assets/audios/attack_start.ogg")
const ATTACK_HIT = preload("res://assets/audios/attack_hit.ogg")
const ATTACK_KILL = preload("res://assets/audios/attack_kill.ogg")

@onready var arena: Node2D = get_tree().get_root().get_node("Arena")
@onready var audio_manager: Node2D = arena.get_node("Map/AudioManager")
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("players")
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_animation_player: AnimationPlayer = $AttackAnimationPlayer
@onready var hurtbox: Area2D = $Hurtbox
@onready var hurtbox_collision_shape_2d: CollisionShape2D = $Hurtbox/CollisionShape2D
@onready var action_timer: Timer = $ActionTimer
@onready var attack_timer: Timer = $AttackTimer

var is_flipped = false
var is_moving = false
var is_reaching = false
var is_attacking = false
var can_move = true
var can_attack = true
var move_speed = 300
var idle_time = 1
var move_time = 4
var attack_time = 0.5
var attack_damage = 1
var maximum_health = 1
var current_health = maximum_health

func _physics_process(_delta: float) -> void:
	
	if player.is_dead:
		animated_sprite_2d.play("attack" if is_attacking else "idle")
		return
	
	if !is_attacking:
		if can_attack and hurtbox.overlaps_body(player):
			is_attacking = true
			is_moving = false
			attack_animation_player.play("attack")
			audio_manager.play_audio(ATTACK_START, global_position)
		elif can_move and !is_moving:
			is_moving = true
			action_timer.start(randf_range(move_time * 0.5, move_time))
		elif !can_move and is_moving:
			is_moving = false
			action_timer.start(randf_range(idle_time * 0.5, idle_time))

	var move_direction = global_position.direction_to(player.global_position)
	velocity = move_speed * move_direction if is_moving else Vector2.ZERO
	move_and_slide()
	
	animated_sprite_2d.play("attack" if is_attacking else "move" if velocity.length() > 0 else "idle")
	if move_direction.x > 0 == is_flipped and !is_attacking:
		is_flipped = !is_flipped
		animated_sprite_2d.flip_h = is_flipped
		hurtbox_collision_shape_2d.position.x = -hurtbox_collision_shape_2d.position.x
		
func _on_attack_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		is_attacking = false
		is_moving = true
		can_move = false
		can_attack = false
		attack_timer.start(attack_time)
		
func _on_action_timer_timeout() -> void:
	can_move = !can_move
	
func _on_attack_timer_timeout() -> void:
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

func attack() -> void:
	if hurtbox.overlaps_body(player):
		var target_health = player.take_damage(attack_damage)
		audio_manager.play_audio(ATTACK_KILL if target_health == 0 else ATTACK_HIT, global_position)
