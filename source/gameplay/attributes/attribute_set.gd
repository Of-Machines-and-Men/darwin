class_name AttributeSet
extends Resource

@export var attributes: Array[AttributeBase] = []

var _attribute_map: Dictionary[StringName, AttributeBase] = {}
var _attribute_map_ready: bool = false

func apply_modifier(_modifier: AttributeModifierBase) -> void:
	# fire on_apply events on pooled attributes
	pass
	
func remove_modifier(_modifier: AttributeModifierBase) -> void:
	# fire on_remove events on pooled attributes
	pass

func get_value(attribute_name: StringName, modifiers: Array[AttributeModifierBase], default: float = 0.0) -> float:
	var attribute = get_attribute(attribute_name)
	return attribute.get_effective_value(modifiers) if attribute else default

func get_attribute(attribute_name: StringName) -> AttributeBase:
	if not _attribute_map_ready:
		initialise_attributes()
	return _attribute_map.get(attribute_name)

func get_attribute_names() -> Array[StringName]:
	if not _attribute_map_ready:
		initialise_attributes()
	return _attribute_map.keys()

func register_attribute(attribute: AttributeBase) -> void:
	var attribute_name = attribute.get_attribute_name()
	if not _attribute_map.get(attribute_name):
		_attribute_map[attribute_name] = attribute
	else:
		push_warning("AttributeSet: duplicate attribute name '%s' — skipping" % attribute_name)

func initialise_attributes() -> void:
	for attribute in attributes:
		register_attribute(attribute)
	_attribute_map_ready = true
	
