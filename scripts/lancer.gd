extends CharacterBody2D

const DUST = preload("res://scenes/dust.tscn")

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("players")
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_animation_player: AnimationPlayer = $AttackAnimationPlayer
@onready var hurtbox: Area2D = $Hurtbox

var is_flipped = false
var is_moving = false
var is_reaching = false
var is_attacking = false
var move_speed = 200
var idle_time = 2
var move_time = 4
var attack_time = 0.5
var current_idle_time = 0
var current_move_time = 0
var current_attack_time = 0
var attack_damage = 1
var maximum_health = 1
var current_health = maximum_health
var reward_score = 1

func _physics_process(delta: float) -> void:
	
	current_idle_time = max(0, current_idle_time - delta)
	current_move_time = max(0, current_move_time - delta)
	current_attack_time = max(0, current_attack_time - delta)
	
	if !is_attacking:
		if current_attack_time == 0 and hurtbox.overlaps_body(player):
			is_attacking = true
			is_moving = false
			attack_animation_player.play("attack")
		elif current_idle_time == 0 and !is_moving:
			is_moving = true
			current_move_time = randf_range(move_time * 0.5, move_time)
		elif current_move_time == 0 and is_moving:
			is_moving = false
			@warning_ignore("integer_division")
			current_idle_time = randf_range(idle_time * 0.5, idle_time)

	var move_direction = global_position.direction_to(player.global_position)
	velocity = move_speed * move_direction if is_moving else Vector2.ZERO
	move_and_slide()
	
	animated_sprite_2d.play("attack" if is_attacking else "move" if velocity.length() > 0 else "idle")
	if move_direction.x > 0 == is_flipped and !is_attacking:
		is_flipped = !is_flipped
		scale.x = -scale.x
		
func _on_attack_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		is_attacking = false
		current_idle_time = attack_time
		current_move_time = 0
		current_attack_time = attack_time
		
func take_damage(damage: int) -> void:
	current_health = current_health - damage
	if current_health <= 0:
		var dust_instance = DUST.instantiate()
		dust_instance.global_position = global_position
		get_tree().get_root().add_child(dust_instance)
		ScoreManager.increase_score(reward_score)
		queue_free()

func attack() -> void:
	if hurtbox.overlaps_body(player):
		player.take_damage(attack_damage)
