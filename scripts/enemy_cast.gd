extends Area2D

@onready var arena: Node2D = get_tree().get_root().get_node("Arena")
@onready var audio_manager: Node2D = arena.get_node("Map/AudioManager")
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("players")
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

var is_warning = true
var warn_time = 1.6
var cast_damage = 0

func _ready() -> void:
	timer.start(warn_time)
	animated_sprite_2d.pause()

func _on_timer_timeout() -> void:
	sprite_2d.visible = false
	animated_sprite_2d.visible = true
	animated_sprite_2d.play()
	animation_player.play("cast")
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "cast":
		queue_free()

func hurt() -> void:
	if overlaps_body(player):
		var target_health = player.take_damage(cast_damage)
		# audio_manager.play_audio(ATTACK_KILL if target_health == 0 else ATTACK_HIT, global_position)
