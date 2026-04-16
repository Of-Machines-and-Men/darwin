class_name IdleState
extends State

func enter() -> void:
	state_machine.play(enter_texture)

func exit() -> void:
	pass

func update(_delta: float) -> void:
	pass
