extends Node

var score = 0

signal score_increased(value: int)

func increase_score(value: int) -> void:
	score = score + value
	score_increased.emit(score)
