class_name AttributeSet
extends Resource

@export var attributes: Array[AttributeBase] = []
@export var modifiers: Array[AttributeModifierBase] = []

var _cached_attributes: Dictionary[StringName, AttributeBase] = {}
var _cache_ready: bool = false

func _prepare_cache() -> void:
	if not _cache_ready:
		for attribute in attributes:
			var attribute_name = attribute.get_attribute_name()
			if not _cached_attributes.get(attribute_name, null):
				_cached_attributes[attribute_name] = attribute
			else:
				push_warning("AttributeSet: duplicate attribute name '%s' — skipping" % attribute_name)
	_cache_ready = true

func get_attribute(name: StringName) -> AttributeBase:
	if not _cache_ready:
		_prepare_cache()
		
	return _cached_attributes.get(name)
	
func get_value(name: StringName, default: float = 0.0) -> float:
	var attribute = get_attribute(name)
	return attribute.get_effective_value(modifiers) if attribute else default
