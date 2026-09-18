extends CharacterBody2D

const DUST = preload("res://scenes/dust.tscn")

@onready var arena: Node2D = get_tree().get_root().get_node("Arena")
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var action_timer: Timer = $ActionTimer

var is_flipped = false
var is_moving = false
var can_move = true
var move_speed = 100
var move_center_bias = 0.66
var move_direction = null
var idle_time = 4
var move_time = 4
var maximum_health = 1
var current_health = maximum_health

func _physics_process(_delta: float) -> void:

	if can_move and !is_moving:
		is_moving = true
		move_direction = Vector2.UP.rotated(randf_range(0, TAU))
		var move_sign_x = 1 if (move_direction.x < 0 and randf() > move_center_bias) or (move_direction.x > 0 and randf() < move_center_bias) else -1
		var move_sign_y = 1 if (move_direction.y < 0 and randf() > move_center_bias) or (move_direction.y > 0 and randf() < move_center_bias) else -1
		move_direction.x = move_sign_x * abs(move_direction.x)
		move_direction.y = move_sign_y * abs(move_direction.y)
		if move_direction.x > 0 == is_flipped:
			is_flipped = !is_flipped
			animated_sprite_2d.flip_h = is_flipped
		action_timer.start(randf_range(move_time * 0.5, move_time))
	elif !can_move and is_moving:
		is_moving = false
		move_direction = null
		action_timer.start(randf_range(idle_time * 0.5, idle_time))

	velocity = move_speed * move_direction if is_moving else Vector2.ZERO
	move_and_slide()
	
	animated_sprite_2d.play("move" if velocity.length() > 0 else "idle")
		
func _on_action_timer_timeout() -> void:
	can_move = !can_move
	
func take_damage(damage: int) -> int:
	current_health = max(0, current_health - damage)
	if current_health == 0:
		var dust_instance = DUST.instantiate()
		dust_instance.global_position = global_position
		arena.add_child(dust_instance)
		queue_free()
	return current_health
