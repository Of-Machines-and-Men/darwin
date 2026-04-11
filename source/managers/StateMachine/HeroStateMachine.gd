class_name HeroStateMachine
extends StateMachine

func _ready() -> void:
	current_state = IdleState.new()
