class_name UpgradeDefinition
extends Resource

@export var upgrade_name: String = ""
@export var description: String = ""
@export var rarity: UpgradeRarity.Rarity = UpgradeRarity.Rarity.COMMON
@export var cost: int = 0
@export var modifiers: Array[AttributeModifierBase] = []

## Applies all modifiers in this upgrade to the given entity.
## Each modifier is duplicated so entities don't share modifier state.
func apply_to(entity: EntityBase) -> void:
	if not entity.modifiers:
		return
	for modifier in modifiers:
		entity.modifiers.apply_modifier(modifier.duplicate(true))
