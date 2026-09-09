extends RigidBody2D

const EXPLOSION = preload("res://scenes/explosion.tscn")
const SHOOT_HIT = preload("res://assets/audios/shoot_hit.ogg")
const SHOOT_KILL = preload("res://assets/audios/shoot_kill.ogg")

@onready var arena: Node2D = get_tree().get_root().get_node("Arena")
@onready var audio_manager: Node2D = arena.get_node("Map/AudioManager")

var contact_damage = 0

func _on_body_entered(body: Node) -> void:
	if body.has_method("take_damage"):
		var target_health = body.take_damage(contact_damage)
		var explosion_instance = EXPLOSION.instantiate()
		explosion_instance.global_position = global_position
		arena.add_child(explosion_instance)
		audio_manager.play_audio(SHOOT_KILL if target_health == 0 else SHOOT_HIT, global_position)
	queue_free()
