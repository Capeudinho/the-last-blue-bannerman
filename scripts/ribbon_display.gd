extends Control

@onready var label: Label = $Label

@export var text = ""

func _ready() -> void:
	set_text(text)

func set_text(value: String) -> void:
	label.text = value
