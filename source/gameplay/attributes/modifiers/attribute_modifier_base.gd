class_name AttributeModifierBase
extends Resource

@export var modifier_tags: Array[StringName] = []

func apply_incoming(incoming_amount: float, _incoming_tags: Array[StringName] = []) -> float:
	return incoming_amount

func apply_outgoing(base_value: float, _outgoing_tags: Array[StringName] = []) -> float:
	return base_value
