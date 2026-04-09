class_name StateMachine
extends Node

signal state_changed(from: State, to: State)

var current_state: State
var states: Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is State:
			child.state_machine = self
			states[child.name.to_lower()] = child
	
	if current_state:
		current_state.enter()

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func transition_to(new_state_name: String) -> void:
	var new_state = states.get(new_state_name.to_lower())
	if not new_state or new_state == current_state:
		return
	if current_state:
		current_state.exit()
	var previous = current_state
	current_state = new_state
	current_state.enter()
	state_changed.emit(previous, current_state)
