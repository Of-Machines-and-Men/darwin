class_name AttributeComponent
extends ComponentBase

@export var attributes: AttributeSet
@export var modifiers: Array[AttributeModifierBase] = []

func apply_modifier(modifier: AttributeModifierBase) -> void:
	# fire on_apply events on pooled attributes
	modifiers.append(modifier)
	
func remove_modifier(modifier: AttributeModifierBase) -> void:
	# fire on_remove events on pooled attributes
	modifiers.erase(modifier)

func get_value(attribute_name: StringName, default: float = 0.0) -> float:
	var attribute = get_attribute(attribute_name)
	if attribute:
		return attribute.get_effective_value(modifiers)
	else:
		return default

func get_attribute(attribute_name: StringName) -> AttributeBase:
	if attributes:
		return attributes.get_attribute(attribute_name)
	return null

func register_attribute(attribute: AttributeBase) -> void:
	if attributes:
		attributes.register_attribute(attribute)

func _tick_modifiers(delta_time: float) -> void:
	for modifier in modifiers:
		modifier.duration -= delta_time
		if (modifier.duration <= 0.0):
			remove_modifier(modifier)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	if attributes:
		attributes.initialise_attributes()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_tick_modifiers(delta)
	pass
