extends Sprite2D

var position_range = 96

func _ready() -> void:
	
	global_position.x = global_position.x + randf_range(-position_range, position_range)
	global_position.y = global_position.y + randf_range(-position_range, position_range)
