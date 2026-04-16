class_name AbilityBase
extends Resource

@export var attributes: AttributeSet
@export var priority: int = 0
@export var tags: Array[StringName] = []

var _is_active: bool = false

signal on_activate_ability(ability: AbilityBase)
signal on_deactivate_ability(ability: AbilityBase)
signal on_tick_ability(ability: AbilityBase, delta_time: float)

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
	on_activate_ability.emit(self)

func _on_deactivated(_caller: EntityBase) -> void:
	_is_active = false

func _can_activate(_caller: EntityBase) -> bool:
	return false
	
func get_current_target(caller: EntityBase) -> EntityBase:
	if caller.behaviour:
		return caller.behaviour.current_target
	else:
		return null

func get_effective_ability_value(attr_name: StringName, caller: EntityBase, default: float = 0.0) -> float:
	if not attributes:
		return default
	var attribute = attributes.get_attribute(attr_name)
	if not attribute:
		return default
	return attribute.get_effective_value(caller.modifiers.get_modifiers_for(attr_name))

func get_resolved_values(caller: EntityBase) -> Dictionary:
	var result: Dictionary = {}
	if not attributes:
		return result
	for attr_name in attributes.get_attribute_names():
		result[attr_name] = get_effective_ability_value(attr_name, caller)
	return result
