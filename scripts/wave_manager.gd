extends Node2D

const KNIGHT = preload("res://scenes/knight.tscn")

@onready var entries = get_tree().get_nodes_in_group("entries")
@onready var enemies = [KNIGHT]

var is_interval = false
var wave_total = 5
var wave_time = 5
var wave_count = 1
var interval_time = 10
var current_wave_time = wave_time
var current_wave_count = wave_count
var current_interval_time = 0

func _physics_process(delta: float) -> void:
	
	if current_wave_count == 0 and get_tree().get_node_count_in_group("enemies") == 0 and !is_interval:
		is_interval = true
		current_interval_time = interval_time
		
	if is_interval:
		current_interval_time = max(0, current_interval_time - delta)
		if current_interval_time == 0:
			is_interval = false
			wave_count = wave_count + 1
			current_wave_count = wave_count
			current_wave_time = 0
			
	else:
		current_wave_time = max(0, current_wave_time - delta)
		if current_wave_time == 0 and current_wave_count != 0:
			current_wave_time = wave_time
			current_wave_count = current_wave_count - 1
			for element in range(wave_total):
				var chosen_enemy = enemies.pick_random()
				var chosen_entry = entries.pick_random()
				var chosen_enemy_instance = chosen_enemy.instantiate()
				chosen_enemy_instance.global_position = chosen_entry.global_position
				get_tree().get_root().add_child(chosen_enemy_instance)
