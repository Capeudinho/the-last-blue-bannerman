extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var dash_animation_player: AnimationPlayer = $DashAnimationPlayer
@onready var shoot_animation_player: AnimationPlayer = $ShootAnimationPlayer

const ARROW = preload("res://scenes/arrow.tscn")

var is_flipped = false
var is_dashing = false
var is_shooting = false
var dash_direction = null
var shoot_position = null
var move_speed = 400
var dash_speed = 1600
var shoot_speed = 1600
var attack_damage = 1

func _physics_process(_delta: float) -> void:
	
	var move_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	velocity = dash_speed * dash_direction if is_dashing else move_speed * move_direction
	move_and_slide()
	
	animated_sprite_2d.play("shoot" if is_shooting else "move" if velocity.length() > 0 else "idle")
	if global_position.x < get_global_mouse_position().x == is_flipped:
		is_flipped = !is_flipped
		scale.x = -scale.x
	
	if Input.is_action_just_pressed("dash") and !is_dashing:
		is_dashing = true
		dash_direction = global_position.direction_to(get_global_mouse_position())
		dash_animation_player.play("dash")
		
	if Input.is_action_pressed("shoot") and !is_shooting:
		is_shooting = true
		shoot_position = get_global_mouse_position()
		shoot_animation_player.play("shoot")

func _on_dash_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "dash":
		is_dashing = false
		dash_direction = null


func _on_shoot_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "shoot":
		is_shooting = false
		shoot_position = null
		
func take_damage(damage: int) -> void:
	print("ouch")

func shoot() -> void:
	var shoot_direction = global_position.direction_to(shoot_position)
	var arrow_instance = ARROW.instantiate()
	arrow_instance.global_position = global_position
	arrow_instance.look_at(shoot_position)
	arrow_instance.apply_impulse(shoot_speed * shoot_direction)
	arrow_instance.attack_damage = attack_damage
	get_tree().get_root().add_child(arrow_instance)
