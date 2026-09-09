extends CanvasLayer

signal transition_over()

enum TransitionType {FADE_IN, FADE_OUT}

@onready var color_rect: ColorRect = $ColorRect

var transition_type: TransitionType = TransitionType.FADE_IN
var transition_duration: float = 0
var transition_color = Color.BLACK

func _ready() -> void:
	color_rect.color = transition_color
	color_rect.modulate.a = 1 if transition_type == TransitionType.FADE_IN else 0
	var tween = get_tree().create_tween()
	tween.tween_property(color_rect, "modulate:a", 0 if transition_type == TransitionType.FADE_IN else 1, transition_duration)
	tween.tween_property(GlobalAudioManager.background_audio, "volume_linear", GlobalAudioManager.base_volume_linear if transition_type == TransitionType.FADE_IN else 0.0, transition_duration)
	await tween.finished
	transition_over.emit()
	queue_free()
