extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var end_timer: Timer = $EndTimer

var end_time = 5

func _ready() -> void:
	player.player_died.connect(_on_player_died)
	ScoreManager.reset_score()

func _on_end_timer_timeout() -> void:
	var game_over_menu = load("res://scenes/game_over_menu.tscn")
	get_tree().change_scene_to_packed(game_over_menu)

func _on_player_died() -> void:
	end_timer.start(end_time)
