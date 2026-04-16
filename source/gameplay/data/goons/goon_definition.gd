class_name GoonDefinition
extends Resource

@export var display_name: String = "Goon"
@export var icon: Texture2D
@export var description: String = ""

@export_group("Economy")
@export var spawn_cost_attribute: SpawnCostAttribute
@export var point_value_attribute: PointValueAttribute

@export_group("Base Entity")
@export var base_entity: PackedScene

@export_group("Entity Config")
@export var abilities: Array[AbilityBase] = []
@export var behaviours: Array[BehaviourBase] = []
@export var modifiers: Array[AttributeModifierBase] = []
@export var health_attribute: PoolAttributeBase

func get_effective_spawn_cost() -> int:
	if not spawn_cost_attribute:
		return 0
	return int(spawn_cost_attribute.get_effective_value(modifiers))


func get_effective_point_value() -> int:
	if not point_value_attribute:
		return 0
	return int(point_value_attribute.get_effective_value(modifiers))


func configure_entity(entity: EntityBase) -> void:
	if entity.abilities and not abilities.is_empty():
		entity.abilities.abilities = abilities.duplicate()
	if entity.behaviour and not behaviours.is_empty():
		entity.behaviour.behaviours = behaviours.duplicate()
	if entity.health and health_attribute:
		entity.health.health_attribute = health_attribute.duplicate()
	if entity.modifiers:
		for modifier in modifiers:
			entity.modifiers.apply_modifier(modifier)
	if entity.health and point_value_attribute:
		entity.health.on_death.connect(
			func(): MutiePointsManager.add_points(get_effective_point_value())
		)
