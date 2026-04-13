class_name HurtState
extends State

func enter() -> void:
	(state_machine as GoonStateMachine).play(GoonStateMachine.HURT_TEX)

func exit() -> void:
	pass

func update(delta: float) -> void:
	pass
