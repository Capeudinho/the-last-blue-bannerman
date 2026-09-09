extends Node

const TRANSITION = preload("res://scenes/transition.tscn")

enum TransitionType{FADE_IN, FADE_OUT}

var transition = null
var target_scene = null
var target_duration = null
var target_color = null

func run_transition(scene: PackedScene, transition_duration: float, transition_color: Color):
	target_scene = scene
	target_duration = transition_duration / 2.0
	target_color = transition_color
	transition = TRANSITION.instantiate()
	transition.transition_type = transition.TransitionType.FADE_OUT
	transition.transition_duration = target_duration
	transition.transition_color = target_color
	transition.transition_over.connect(_on_transition_over)
	get_tree().get_root().add_child(transition)
	
func _on_transition_over():
	get_tree().change_scene_to_packed(target_scene)
	transition = TRANSITION.instantiate()
	transition.transition_type = transition.TransitionType.FADE_IN
	transition.transition_duration = target_duration
	transition.transition_color = target_color
	get_tree().get_root().add_child(transition)
	await get_tree().process_frame
