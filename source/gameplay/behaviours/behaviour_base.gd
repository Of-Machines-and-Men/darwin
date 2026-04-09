class_name BehaviourBase
extends Resource

@export var priority: int = 0

func get_destination(_caller: EntityBase, _target: EntityBase) -> Vector2:
	return _caller.global_position

func process(_caller: EntityBase, _target: EntityBase, _delta_time: float) -> void:
	pass

func can_activate(_caller: EntityBase, _target: EntityBase) -> bool:
	return false

func activate(_caller: EntityBase, _target: EntityBase) -> void:
	pass
	
func deactivate(_caller: EntityBase, _target: EntityBase) -> void:
	pass
