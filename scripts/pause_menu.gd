extends CanvasLayer

@onready var arena: Node2D = get_tree().get_root().get_node("Arena")

var is_paused = false

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		toggle_pause()

func toggle_pause() -> void:
	is_paused = !is_paused
	arena.process_mode = Node.PROCESS_MODE_DISABLED if is_paused else Node.PROCESS_MODE_INHERIT
	visible = is_paused

func _on_resume_ribbon_button_pressed() -> void:
	toggle_pause()

func _on_end_ribbon_button_pressed() -> void:
	var game_over_menu = load("res://scenes/game_over_menu.tscn")
	TransitionManager.run_transition(game_over_menu, 2, Color("b65555"))
