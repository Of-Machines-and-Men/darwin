class_name UpgradeDatabase
extends Resource

@export var upgrades: Array[UpgradeDefinition] = []

## Returns `count` unique upgrades, rolling rarity for each slot.
## If no upgrades exist at the rolled rarity, falls back to any available.
func roll_upgrades(count: int = 3) -> Array[UpgradeDefinition]:
	var result: Array[UpgradeDefinition] = []
	var remaining: Array[UpgradeDefinition] = upgrades.duplicate()

	for i in count:
		if remaining.is_empty():
			break

		var rarity: UpgradeRarity.Rarity = UpgradeRarity.roll_rarity()
		var pool: Array[UpgradeDefinition] = _get_by_rarity(remaining, rarity)

		# Fallback: if nothing at that rarity, use whatever's left
		if pool.is_empty():
			pool = remaining.duplicate()

		var chosen: UpgradeDefinition = pool[randi() % pool.size()]
		result.append(chosen)
		remaining.erase(chosen)

	return result

func get_by_rarity(rarity: UpgradeRarity.Rarity) -> Array[UpgradeDefinition]:
	return _get_by_rarity(upgrades, rarity)

func _get_by_rarity(source: Array[UpgradeDefinition], rarity: UpgradeRarity.Rarity) -> Array[UpgradeDefinition]:
	var result: Array[UpgradeDefinition] = []
	for upgrade in source:
		if upgrade.rarity == rarity:
			result.append(upgrade)
	return result