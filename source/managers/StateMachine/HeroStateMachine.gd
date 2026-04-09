class_name HeroStateMachine
extends StateMachine

enum State {
	IDLE,
	WALK,
	ATTACK,
	HURT,
	DEATH
}

func _ready() -> void:
	current_state = State.IDLE
