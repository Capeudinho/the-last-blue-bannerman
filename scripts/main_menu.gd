extends Control

func _on_play_ribbon_button_pressed() -> void:
	var arena = load("res://scenes/arena.tscn")
	get_tree().change_scene_to_packed(arena)

func _on_exit_ribbon_button_pressed() -> void:
	get_tree().quit()
