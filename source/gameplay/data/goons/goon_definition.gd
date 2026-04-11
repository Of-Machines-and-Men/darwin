class_name GoonDefinition
extends Resource

@export var display_name: String = "Goon"
@export var icon: Texture2D
@export var description: String = ""

@export_group("Economy")
@export var spawn_cost: int = 2
@export var death_value: int = 1

@export_group("Base Entity")
@export var base_entity: PackedScene

@export_group("Entity Config")
@export var abilities: Array[AbilityBase] = []
@export var behaviours: Array[BehaviourBase] = []
@export var modifiers: Array[AttributeModifierBase] = []
@export var health_attribute: PoolAttributeBase

func configure_entity(entity: EntityBase) -> void:
	if entity.abilities:
		entity.abilities.abilities = abilities.duplicate()
	if entity.behaviour:
		entity.behaviour.behaviours = behaviours.duplicate()
	if entity.health and health_attribute:
		entity.health.health_attribute = health_attribute.duplicate()
	if entity.modifiers:
		for modifier in modifiers:
			entity.modifiers.apply_modifier(modifier)
