class_name BehaviourBase
extends Resource

@export var priority: int = 0

func activate(_caller: EntityBase) -> void:
	pass

func deactivate(_caller: EntityBase) -> void:
	pass
	
func tick(_caller: EntityBase, _delta_time: float) -> void:
	pass

func can_activate(_caller: EntityBase) -> bool:
	return false
