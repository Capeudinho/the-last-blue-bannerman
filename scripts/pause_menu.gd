extends CanvasLayer

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		toggle_pause()

func toggle_pause() -> void:
	get_tree().paused = !get_tree().paused
	visible = get_tree().paused

func _on_resume_ribbon_button_pressed() -> void:
	toggle_pause()

func _on_end_ribbon_button_pressed() -> void:
	get_tree().paused = false
	var main_menu = load("res://scenes/main_menu.tscn")
	TransitionManager.run_transition(main_menu, 2, Color("b65555"))
