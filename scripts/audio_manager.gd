extends Node2D

const AUDIO_EFFECT = preload("res://scenes/audio_effect.tscn")

func play_audio(audio_stream: AudioStream, audio_position: Vector2) -> void:
	var audio_effect = AUDIO_EFFECT.instantiate()
	audio_effect.stream = audio_stream
	audio_effect.global_position = audio_position
	add_child(audio_effect)
	audio_effect.play()
	audio_effect.finished.connect(audio_effect.queue_free)
