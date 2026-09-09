extends AnimatedSprite2D

var animations = ["default_1", "default_2", "default_3", "default_4"]

func _ready() -> void:
	var random_animation = animations.pick_random()
	var frame_count = sprite_frames.get_frame_count(random_animation)
	frame = randi_range(0, frame_count)
	play(random_animation)
