extends Node

signal score_increased(value: int)

var score = 0

func increase_score() -> void:
	score = score + 1
	score_increased.emit(score)

func reset_score() -> void:
	score = 0
