class_name AttributeBase
extends Resource

@export var base_value: float = 1.0

func get_attribute_name() -> StringName:
	return &"Attribute"
	
func _get_applicable_modifiers(modifiers: Array[AttributeModifierBase], modifier_applicability: Array[AttributeModifierBase.ModifierApplicability] = []) -> Array[AttributeModifierBase]:
	var applicable_modifiers: Array[AttributeModifierBase] = []
	for modifier in modifiers:
		if get_attribute_name() in modifier.affected_attributes and modifier.applicability in modifier_applicability:
			applicable_modifiers.append(modifier)
	
	return applicable_modifiers
	
func _get_applicable_read_modifiers(modifiers: Array[AttributeModifierBase]) -> Array[AttributeModifierBase]:
	var applicability: Array[AttributeModifierBase.ModifierApplicability] = [AttributeModifierBase.ModifierApplicability.ALWAYS, AttributeModifierBase.ModifierApplicability.ON_READ]
	return _get_applicable_modifiers(modifiers, applicability)
	
func _apply_modifiers_to_value(value: float, applicable_modifiers: Array[AttributeModifierBase]) -> float:
	var accumulated_value = value
	var additive_flat_sum = 0.0
	var additive_percent_sum = 0.0
	var multiplicative_flat_product = 1.0
	var multiplicative_percent_sum = 0.0
	
	for modifier in applicable_modifiers:
		match modifier.modifier_type:
			AttributeModifierBase.ModifierType.STATIC:
				return modifier.magnitude
			AttributeModifierBase.ModifierType.ADDITIVE_FLAT:
				additive_flat_sum += modifier.magnitude
			AttributeModifierBase.ModifierType.ADDITIVE_PERCENT:
				additive_percent_sum += modifier.magnitude
			AttributeModifierBase.ModifierType.MULTIPLICATIVE_FLAT:
				multiplicative_flat_product *= modifier.magnitude
			AttributeModifierBase.ModifierType.MULTIPLICATIVE_PERCENT:
				multiplicative_percent_sum += modifier.magnitude
	
	accumulated_value += additive_flat_sum
	accumulated_value *= (1.0 + additive_percent_sum)
	accumulated_value *= (1.0 + multiplicative_percent_sum)
	accumulated_value *= multiplicative_flat_product
	
	return accumulated_value

func get_effective_value(modifiers: Array[AttributeModifierBase] = []) -> float:
	var applicable_modifiers = _get_applicable_read_modifiers(modifiers)
	return _apply_modifiers_to_value(base_value, applicable_modifiers)
	
func on_apply_modifier(_new_modifier: AttributeModifierBase, _existing_modifiers: Array[AttributeModifierBase]) -> void:
	pass

func on_remove_modifier(_removed_modifier: AttributeModifierBase, _existing_modifiers: Array[AttributeModifierBase]) -> void:
	pass
