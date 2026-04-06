class_name AbilityBase
extends Resource

@export var attributes: AttributeSet
@export var priority: int = 0
@export var tags: Array[StringName] = []

var _is_active: bool = false

func _process(_caller: EntityBase, _delta_time: float) -> void:
	pass

func tick(caller: EntityBase, _delta_time: float) -> void:
	if _can_activate(caller):
		if not _is_active:
			_on_activated(caller)
		_process(caller, _delta_time)
	elif _is_active:
		_on_deactivated(caller)
	
func _on_activated(_caller: EntityBase) -> void:
	_is_active = true

func _on_deactivated(_caller: EntityBase) -> void:
	_is_active = false

func _can_activate(_caller: EntityBase) -> bool:
	return false
