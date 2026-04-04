class_name AbilityBase
extends Resource

@export var priority: int = 0
@export var tags: Array[StringName] = []

func tick(_caller: EntityBase, _delta_time: float) -> void:
	pass
	
func on_activated(_caller: EntityBase) -> void:
	pass

func on_deactivated(_caller: EntityBase) -> void:
	pass

func can_activate(_caller: EntityBase) -> bool:
	return false
