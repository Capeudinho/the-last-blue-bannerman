extends Node

const GLOBAL_AUDIO_EFFECT = preload("res://scenes/global_audio_effect.tscn")

var background_audio = null

func _ready() -> void:
	background_audio = GLOBAL_AUDIO_EFFECT.instantiate()
	background_audio.volume_linear = 0.33
	add_child(background_audio)

func play_audio(audio_stream: AudioStream) -> void:
	var global_audio_effect = GLOBAL_AUDIO_EFFECT.instantiate()
	global_audio_effect.stream = audio_stream
	global_audio_effect.volume_linear = 0.33
	add_child(global_audio_effect)
	global_audio_effect.play()
	global_audio_effect.finished.connect(global_audio_effect.queue_free)

func set_background_audio(audio_stream: AudioStream) -> void:
	background_audio.stream = audio_stream
	background_audio.play()
