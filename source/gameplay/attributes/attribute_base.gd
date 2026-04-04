class_name AttributeBase
extends Resource

@export var base_value: float = 1.0
@export var modifiers: Array[AttributeModifierBase] = []

func get_attribute_name() -> StringName:
	return &"Attribute"

func get_effective_value(additional_modifiers: Array[AttributeModifierBase] = []):
	var accumulated_value = base_value
	var all_modifiers = modifiers.duplicate()
	all_modifiers.append_array(additional_modifiers)
	
	for modifier in all_modifiers:
		accumulated_value = modifier.apply_outgoing(accumulated_value)
		
	return accumulated_value

func apply_modifier(modifier: AttributeModifierBase) -> void:
	modifiers.append(modifier)
	on_apply_modifier.emit(modifier)
	
func remove_modifier(modifier: AttributeModifierBase) -> void:
	on_remove_modifier.emit(modifier)
	modifiers.erase(modifier)
	

signal on_apply_modifier(modifier: AttributeModifierBase)
signal on_remove_modifier(modifier: AttributeModifierBase)
