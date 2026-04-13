## For now, this is fine since we only have a few upgrades, but if we want to add more it might be worth it to switch to a data-driven approach.
class_name DefaultUpgradeDatabase
extends UpgradeDatabase

func _init() -> void:
	upgrades = []
	_build_common()
	_build_rare()
	_build_epic()

# COMMON RARITY

func _build_common() -> void:
	upgrades.append(_make_upgrade(
		"Thick Skin",
		"Goon max health +20%.",
		UpgradeRarity.Rarity.COMMON,
		[_mod([AttributeNames.HEALTH], AttributeModifierBase.ModifierType.ADDITIVE_PERCENT, 0.2)]
	))

	upgrades.append(_make_upgrade(
		"Quick Feet",
		"Move speed +15%.",
		UpgradeRarity.Rarity.COMMON,
		[_mod([AttributeNames.MOVE_SPEED], AttributeModifierBase.ModifierType.ADDITIVE_PERCENT, 0.15)]
	))

	upgrades.append(_make_upgrade(
		"Hamfists",
		"Melee damage +15%.",
		UpgradeRarity.Rarity.COMMON,
		[_mod([AttributeNames.MELEE_ATTACK_DAMAGE], AttributeModifierBase.ModifierType.ADDITIVE_PERCENT, 0.15)]
	))

	upgrades.append(_make_upgrade(
		"Frantic Strikes",
		"Melee attack speed +10%.",
		UpgradeRarity.Rarity.COMMON,
		[_mod([AttributeNames.MELEE_ATTACK_SPEED], AttributeModifierBase.ModifierType.ADDITIVE_PERCENT, 0.1)]
	))

	upgrades.append(_make_upgrade(
		"Long Arms",
		"Melee attack range +20%.",
		UpgradeRarity.Rarity.COMMON,
		[_mod([AttributeNames.MELEE_ATTACK_RANGE], AttributeModifierBase.ModifierType.ADDITIVE_PERCENT, 0.2)]
	))

# RARE RARITY

func _build_rare() -> void:
	upgrades.append(_make_upgrade(
		"Adrenal Boost",
		"Attack speed +30%.",
		UpgradeRarity.Rarity.RARE,
		[_mod([AttributeNames.MELEE_ATTACK_SPEED], AttributeModifierBase.ModifierType.ADDITIVE_PERCENT, 0.3)]
	))

	upgrades.append(_make_upgrade(
		"Wide Swing",
		"Melee AOE +50%.",
		UpgradeRarity.Rarity.RARE,
		[_mod([AttributeNames.MELEE_ATTACK_AOE], AttributeModifierBase.ModifierType.ADDITIVE_PERCENT, 0.5)]
	))

	upgrades.append(_make_upgrade(
		"Predator",
		"Melee damage +25%, attack range +25%.",
		UpgradeRarity.Rarity.RARE,
		[
			_mod([AttributeNames.MELEE_ATTACK_DAMAGE], AttributeModifierBase.ModifierType.ADDITIVE_PERCENT, 0.25),
			_mod([AttributeNames.MELEE_ATTACK_RANGE], AttributeModifierBase.ModifierType.ADDITIVE_PERCENT, 0.25),
		]
	))

	upgrades.append(_make_upgrade(
		"Iron Will",
		"Max health +40%.",
		UpgradeRarity.Rarity.RARE,
		[_mod([AttributeNames.HEALTH], AttributeModifierBase.ModifierType.ADDITIVE_PERCENT, 0.4)]
	))

	upgrades.append(_make_upgrade(
		"Berserker",
		"Melee damage +35%, move speed -10%.",
		UpgradeRarity.Rarity.RARE,
		[
			_mod([AttributeNames.MELEE_ATTACK_DAMAGE], AttributeModifierBase.ModifierType.ADDITIVE_PERCENT, 0.35),
			_mod([AttributeNames.MOVE_SPEED], AttributeModifierBase.ModifierType.ADDITIVE_PERCENT, -0.1),
		]
	))

# EPIC RARITY

func _build_epic() -> void:
	upgrades.append(_make_upgrade(
		"Alpha Gene",
		"Health +50%, melee damage +50%, move speed +30%.",
		UpgradeRarity.Rarity.EPIC,
		[
			_mod([AttributeNames.HEALTH], AttributeModifierBase.ModifierType.ADDITIVE_PERCENT, 0.5),
			_mod([AttributeNames.MELEE_ATTACK_DAMAGE], AttributeModifierBase.ModifierType.ADDITIVE_PERCENT, 0.5),
			_mod([AttributeNames.MOVE_SPEED], AttributeModifierBase.ModifierType.ADDITIVE_PERCENT, 0.3),
		]
	))

	upgrades.append(_make_upgrade(
		"Juggernaut",
		"Health +100%, melee damage +40%, move speed -20%.",
		UpgradeRarity.Rarity.EPIC,
		[
			_mod([AttributeNames.HEALTH], AttributeModifierBase.ModifierType.ADDITIVE_PERCENT, 1.0),
			_mod([AttributeNames.MELEE_ATTACK_DAMAGE], AttributeModifierBase.ModifierType.ADDITIVE_PERCENT, 0.4),
			_mod([AttributeNames.MOVE_SPEED], AttributeModifierBase.ModifierType.ADDITIVE_PERCENT, -0.2),
		]
	))

	upgrades.append(_make_upgrade(
		"Frenzy Mutation",
		"Attack speed +60%, melee damage +40%, melee AOE +60%.",
		UpgradeRarity.Rarity.EPIC,
		[
			_mod([AttributeNames.MELEE_ATTACK_SPEED], AttributeModifierBase.ModifierType.ADDITIVE_PERCENT, 0.6),
			_mod([AttributeNames.MELEE_ATTACK_DAMAGE], AttributeModifierBase.ModifierType.ADDITIVE_PERCENT, 0.4),
			_mod([AttributeNames.MELEE_ATTACK_AOE], AttributeModifierBase.ModifierType.ADDITIVE_PERCENT, 0.6),
		]
	))

# Helpers

func _make_upgrade(
	upgrade_name: String,
	description: String,
	rarity: UpgradeRarity.Rarity,
	modifiers: Array[AttributeModifierBase]
) -> UpgradeDefinition:
	var def := UpgradeDefinition.new()
	def.upgrade_name = upgrade_name
	def.description = description
	def.rarity = rarity
	def.cost = UpgradeRarity.get_base_cost(rarity)
	def.modifiers = modifiers
	return def

func _mod(
	attributes: Array[StringName],
	type: AttributeModifierBase.ModifierType,
	magnitude: float
) -> AttributeModifierBase:
	var m := AttributeModifierBase.new()
	m.affected_attributes = attributes
	m.modifier_type = type
	m.magnitude = magnitude
	m.applicability = AttributeModifierBase.ModifierApplicability.ALWAYS
	m.duration = INF
	return m