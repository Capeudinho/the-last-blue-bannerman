extends Node2D

const KNIGHT = preload("res://scenes/knight.tscn")
const LANCER = preload("res://scenes/lancer.tscn")
const PAWN = preload("res://scenes/pawn.tscn")
const ARCHER = preload("res://scenes/archer.tscn")

@onready var arena: Node2D = get_tree().get_root().get_node("Arena")
@onready var entries = get_tree().get_nodes_in_group("entries")
@onready var enemies = [KNIGHT, LANCER, PAWN, ARCHER]
@onready var interval_timer: Timer = $IntervalTimer
@onready var wave_timer: Timer = $WaveTimer

var is_interval = false
var is_wave = false
var interval_time = 8
var start_time = 4
var wave_time = 2
var wave_total = 4
var wave_count = 0
var current_wave_count = 0

func _ready() -> void:
	is_interval = true
	interval_timer.start(start_time)

func _physics_process(_delta: float) -> void:
	
	if !is_interval:
	
		if current_wave_count == 0 and get_tree().get_node_count_in_group("enemies") == 0:
			is_interval = true
			interval_timer.start(interval_time)
				
		if current_wave_count != 0 and !is_wave:
			is_wave = true
			wave_timer.start(wave_time)
			for element in range(wave_total):
				var chosen_enemy = enemies.pick_random()
				var chosen_entry = entries.pick_random()
				var chosen_enemy_instance = chosen_enemy.instantiate()
				chosen_enemy_instance.global_position = chosen_entry.global_position
				arena.add_child(chosen_enemy_instance)

func _on_interval_timer_timeout() -> void:
	is_interval = false
	wave_count = wave_count + 1
	current_wave_count = wave_count

func _on_wave_timer_timeout() -> void:
	is_wave = false
	current_wave_count = current_wave_count - 1
