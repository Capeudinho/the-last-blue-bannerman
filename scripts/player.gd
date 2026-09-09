extends CharacterBody2D

const PLAYER_ARROW = preload("res://scenes/player_arrow.tscn")
const DUST = preload("res://scenes/dust.tscn")
const SHOOT_START = preload("res://assets/audios/shoot_start.ogg")
const DASH_START = preload("res://assets/audios/dash_start.ogg")

signal player_died()

@onready var arena: Node2D = get_tree().get_root().get_node("Arena")
@onready var audio_manager: Node2D = arena.get_node("Map/AudioManager")
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var dash_animation_player: AnimationPlayer = $DashAnimationPlayer
@onready var shoot_animation_player: AnimationPlayer = $ShootAnimationPlayer

var is_dead = false
var is_flipped = false
var is_dashing = false
var is_shooting = false
var dash_direction = null
var shoot_position = null
var move_speed = 400
var dash_speed = 1600
var shoot_speed = 1600
var shoot_damage = 1
var maximum_health = 1
var current_health = maximum_health

func _physics_process(_delta: float) -> void:
	
	if is_dead:
		return
	
	var move_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	velocity = dash_speed * dash_direction if is_dashing else move_speed * move_direction
	move_and_slide()
	
	animated_sprite_2d.play("shoot" if is_shooting else "move" if velocity.length() > 0 else "idle")
	if global_position.x < get_global_mouse_position().x == is_flipped:
		is_flipped = !is_flipped
		animated_sprite_2d.flip_h = is_flipped
	
	if Input.is_action_just_pressed("dash") and !is_dashing:
		is_dashing = true
		dash_direction = global_position.direction_to(get_global_mouse_position())
		set_collision_layer_value(1, false)
		set_collision_layer_value(3, true)
		dash_animation_player.play("dash")
		audio_manager.play_audio(DASH_START, global_position)
		
	if Input.is_action_pressed("shoot") and !is_shooting:
		is_shooting = true
		shoot_position = get_global_mouse_position()
		shoot_animation_player.play("shoot")
		audio_manager.play_audio(SHOOT_START, global_position)

func _on_dash_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "dash":
		is_dashing = false
		dash_direction = null
		set_collision_layer_value(1, true)
		set_collision_layer_value(3, false)

func _on_shoot_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "shoot":
		is_shooting = false
		shoot_position = null
		
func take_damage(damage: int) -> int:
	current_health = max(0, current_health - damage)
	if current_health == 0:
		is_dead = true
		visible = false
		player_died.emit()
		var dust_instance = DUST.instantiate()
		dust_instance.global_position = global_position
		arena.add_child(dust_instance)
	return current_health

func shoot() -> void:
	var shoot_direction = global_position.direction_to(shoot_position)
	var player_arrow_instance = PLAYER_ARROW.instantiate()
	player_arrow_instance.global_position = global_position
	player_arrow_instance.look_at(shoot_position)
	player_arrow_instance.apply_impulse(shoot_speed * shoot_direction)
	player_arrow_instance.contact_damage = shoot_damage
	arena.add_child(player_arrow_instance)
