extends AnimatedSprite2D

func _ready() -> void:

	var frame_count = sprite_frames.get_frame_count("default")
	frame = randi_range(0, frame_count)
