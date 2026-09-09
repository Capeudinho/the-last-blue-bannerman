extends Control

@onready var message_rich_text_label: RichTextLabel = $MarginContainer/VBoxContainer/MessageRichTextLabel

func _ready() -> void:
	message_rich_text_label.text = "You Outlived Your Will To Fight" if ScoreManager.score == 0 else "You Outlived "+str(ScoreManager.score)+" Red Traitor" if ScoreManager.score == 1 else "You Outlived "+str(ScoreManager.score)+" Red Traitors"

func _on_play_ribbon_button_pressed() -> void:
	var arena = load("res://scenes/arena.tscn")
	get_tree().change_scene_to_packed(arena)

func _on_main_ribbon_button_pressed() -> void:
	var main_menu = load("res://scenes/main_menu.tscn")
	get_tree().change_scene_to_packed(main_menu)
