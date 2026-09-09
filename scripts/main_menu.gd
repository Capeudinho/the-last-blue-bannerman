extends Control

const BACKGROUND_MENU = preload("res://assets/audios/background_menu.ogg")

func _ready() -> void:
	GlobalAudioManager.set_background_audio(BACKGROUND_MENU)

func _on_play_ribbon_button_pressed() -> void:
	var arena = load("res://scenes/arena.tscn")
	get_tree().change_scene_to_packed(arena)

func _on_exit_ribbon_button_pressed() -> void:
	get_tree().quit()
