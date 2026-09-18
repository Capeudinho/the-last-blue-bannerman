extends Node2D

@onready var hazard: Area2D = $Hazard
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("players")

func _ready() -> void:
	player.dash_ended.connect(_on_player_dash_ended)

func _on_player_dash_ended() -> void:
	if hazard.get_overlapping_bodies().has(player):
		player.take_damage(player.current_health)
