class_name StateMachine
extends Node

signal state_changed(from: int, to: int)

var current_state: int = 0
var previous_state: int = 0

func transition_to(new_state: int) -> void:
	if new_state == current_state:
		return
	previous_state = current_state
	current_state = new_state
	state_changed.emit(previous_state, current_state)

func get_state() -> int:
	return current_state
