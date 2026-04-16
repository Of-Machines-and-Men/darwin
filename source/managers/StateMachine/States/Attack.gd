class_name AttackState
extends State

const HOLD_DURATION: float = 0.3
var _timer: float = 0.0

func enter() -> void:
	state_machine.play(enter_texture)
	_timer = HOLD_DURATION

func exit() -> void:
	pass

func update(delta: float) -> void:
	_timer -= delta
	if _timer <= 0.0:
		state_machine.transition_to("idle")
