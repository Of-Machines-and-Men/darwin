class_name WalkState
extends State

func enter() -> void:
	(state_machine as GoonStateMachine).play(GoonStateMachine.MOVE_TEX)

func exit() -> void:
	pass

func update(delta: float) -> void:
	pass
