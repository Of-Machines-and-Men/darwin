
class_name HealthComponent
extends ComponentBase

@export var health_attribute: PoolAttributeBase

var _current_modifiers: Array[AttributeModifierBase] = []

signal on_damaged(amount: float, remaining: float, tags: Array[StringName])
signal on_restored(amount: float, remaining: float, tags: Array[StringName])
signal on_death()

func apply_damage(amount: float, tags: Array[StringName] = []) -> void:
	print("received damage")
	if health_attribute:
		var modifiers: Array[AttributeModifierBase] = []
		if _parent.modifiers:
			modifiers = _parent.modifiers.get_modifiers_for(health_attribute.get_attribute_name())
		health_attribute.deplete(amount, modifiers, tags)

func heal_damage(amount: float, tags: Array[StringName] = []) -> void:
	if health_attribute:
		var modifiers: Array[AttributeModifierBase] = []
		if _parent.modifiers:
			modifiers = _parent.modifiers.get_modifiers_for(health_attribute.get_attribute_name())
		health_attribute.restore(amount, modifiers, tags)
	
func _on_apply_modifier(new_modifier, existing_modifiers) -> void:
	if health_attribute:
		health_attribute.on_apply_modifier(new_modifier, existing_modifiers)

func _on_remove_modifier(removed_modifier, existing_modifiers) -> void:
	if health_attribute:
		health_attribute.on_remove_modifier(removed_modifier, existing_modifiers)

func _on_damage_received(amount: float, remaining: float, tags: Array[StringName] = []) -> void:
	on_damaged.emit(amount, remaining, tags)
	
func _on_health_restored(amount: float, remaining: float, tags: Array[StringName] = []) -> void:
	on_restored.emit(amount, remaining, tags)
	
func _on_health_empty() -> void:
	print("death detected")
	on_death.emit()

func _ready() -> void:
	super._ready()
	if health_attribute and _parent.modifiers:
		_current_modifiers = _parent.modifiers.get_modifiers_for(health_attribute.get_attribute_name())
