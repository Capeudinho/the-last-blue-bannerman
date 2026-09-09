extends Control

const BACKGROUND_MENU = preload("res://assets/audios/background_menu.ogg")

@onready var message_rich_text_label: RichTextLabel = $MarginContainer/VBoxContainer/MessageRichTextLabel

func _ready() -> void:
	message_rich_text_label.text = "You Outlived Your Will To Fight" if ScoreManager.score == 0 else "You Outlived "+str(ScoreManager.score)+" Red Loyalist" if ScoreManager.score == 1 else "You Outlived "+str(ScoreManager.score)+" Red Loyalists"
	GlobalAudioManager.set_background_audio(BACKGROUND_MENU)

func _on_play_ribbon_button_pressed() -> void:
	var arena = load("res://scenes/arena.tscn")
	TransitionManager.run_transition(arena, 2, Color("b65555"))

func _on_main_ribbon_button_pressed() -> void:
	var main_menu = load("res://scenes/main_menu.tscn")
	TransitionManager.run_transition(main_menu, 2, Color("b65555"))
