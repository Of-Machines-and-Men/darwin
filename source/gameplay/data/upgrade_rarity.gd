class_name UpgradeRarity

enum Rarity { COMMON, RARE, EPIC }

const WEIGHTS: Dictionary = {
	Rarity.COMMON: 60,
	Rarity.RARE:   30,
	Rarity.EPIC:   10,
}

const DISPLAY_NAMES: Dictionary = {
	Rarity.COMMON: "Common",
	Rarity.RARE:   "Rare",
	Rarity.EPIC:   "Epic",
}

const COSTS: Dictionary = {
	Rarity.COMMON: 5,
	Rarity.RARE:   15,
	Rarity.EPIC:   30,
}

static func roll_rarity() -> Rarity:
	var total_weight: int = 0
	for w in WEIGHTS.values():
		total_weight += w

	var roll: int = randi_range(1, total_weight)
	var cumulative: int = 0
	for rarity in WEIGHTS:
		cumulative += WEIGHTS[rarity]
		if roll <= cumulative:
			return rarity
	return Rarity.COMMON

static func get_display_name(rarity: Rarity) -> String:
	return DISPLAY_NAMES.get(rarity, "Unknown")

static func get_base_cost(rarity: Rarity) -> int:
	return COSTS.get(rarity, 0)