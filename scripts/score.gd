extends Control

@onready var label: Label = $Label

func _ready() -> void:
	ScoreManager.score_increased.connect(_on_score_increased)
	label.text = str(ScoreManager.score)

func _on_score_increased(value: int) -> void:
	label.text = str(value)
