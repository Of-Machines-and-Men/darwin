class_name GoonStateMachine
extends StateMachine

enum State {
	IDLE,
	WALK,
	ATTACK,
	UPGRADE,
	EVOLVE,
	HURT,
	DEATH
}

func _ready() -> void:
	current_state = State.IDLE
