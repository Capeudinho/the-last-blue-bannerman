extends Node

signal score_updated(value: int)

var score = 0

func increase_score() -> void:
	score = score + 1
	score_updated.emit(score)

func reset_score() -> void:
	score = 0
	score_updated.emit(score)
