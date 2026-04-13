class_name IdleState
extends State

func enter() -> void:
	(state_machine as GoonStateMachine).play(GoonStateMachine.IDLE_TEX)

func exit() -> void:
	pass

func update(delta: float) -> void:
	pass
