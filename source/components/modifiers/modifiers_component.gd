class_name ModifiersComponent
extends ComponentBase

@export var modifiers: Array[AttributeModifierBase] = []

signal on_apply_modifier(new_modifier: AttributeModifierBase, existing_modifiers: Array[AttributeModifierBase])
signal on_remove_modifier(removed_modifier: AttributeModifierBase, existing_modifiers: Array[AttributeModifierBase])

func apply_modifier(modifier: AttributeModifierBase) -> void:
	on_apply_modifier.emit(modifier, modifiers)
	modifiers.append(modifier)
	
func remove_modifier(modifier: AttributeModifierBase) -> void:
	on_remove_modifier.emit(modifier, modifiers)
	modifiers.erase(modifier)

func get_modifiers_for(attr_name: StringName) -> Array[AttributeModifierBase]:
	var result: Array[AttributeModifierBase] = []
	for modifier in modifiers:
		if attr_name in modifier.affected_attributes:
			result.append(modifier)
	return result

func _tick_modifiers(delta_time: float) -> void:
	for modifier in modifiers:
		modifier.duration -= delta_time
		if (modifier.duration <= 0.0):
			remove_modifier(modifier)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_tick_modifiers(delta)
	pass
