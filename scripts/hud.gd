extends CanvasLayer

@onready var ribbon_display: Control = $MarginContainer/RibbonDisplay

func _ready() -> void:
	ScoreManager.score_updated.connect(_on_score_updated)
	ribbon_display.set_text(str(ScoreManager.score))

func _on_score_updated(value: int) -> void:
	ribbon_display.set_text(str(value))
