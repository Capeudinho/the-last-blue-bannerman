extends AnimatedSprite2D

var animations = ["default_1", "default_2", "default_3", "default_4"]
var position_range = 96

func _ready() -> void:
	
	global_position.x = global_position.x + randf_range(-position_range, position_range)
	global_position.y = global_position.y + randf_range(-position_range, position_range)
	var random_animation = animations.pick_random()
	animation = random_animation
	play(random_animation)
