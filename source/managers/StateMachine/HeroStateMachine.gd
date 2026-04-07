extends Node

enum State {
	IDLE,
	WALK,
	ATTACK,
	HURT,
	DEATH
}

var current_state: State = State.IDLE
var previous_state: State = State.IDLE

signal state_changed(from: State, to: State)

func transition_to(new_state: State) -> void:
	if new_state == current_state:
		return
	previous_state = current_state
	current_state = new_state
	state_changed.emit(previous_state, current_state)

func get_state() -> State:
	return current_state
