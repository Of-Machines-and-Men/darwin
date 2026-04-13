class_name AttackState
extends State

func enter() -> void:
	(state_machine as GoonStateMachine).play(GoonStateMachine.ATTACK_TEX)

func exit() -> void:
	pass

func update(delta: float) -> void:
	pass
