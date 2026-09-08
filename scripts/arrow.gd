extends RigidBody2D

const EXPLOSION = preload("res://scenes/explosion.tscn")

var attack_damage = 0

func _on_body_entered(body: Node) -> void:
	if body.has_method("take_damage"):
		body.take_damage(attack_damage)
		var explosion_instance = EXPLOSION.instantiate()
		explosion_instance.global_position = global_position
		get_tree().get_root().add_child(explosion_instance)
	queue_free()
