class_name RoundManager
extends Node

signal round_started(round_number: int)
signal round_ended(round_number: int)
signal hero_enraged(stack_count: int)

const GOON_SCENE: PackedScene = preload("res://source/entities/goon/goon.tscn")
const LAB_MENU_SCENE: PackedScene = preload("res://source/scenes/UI/LabMenu.tscn")
const ROUND_TRANSITION_SCENE: PackedScene = preload("res://source/scenes/UI/RoundTransition.tscn")

@export var spawn_points: Array[NodePath] = []
@export var goon_container: NodePath

@export var round_time_limit: float = 90.0
@export var enrage_damage_bonus: float = 0.25
@export var enrage_speed_bonus: float = 0.20

const BASE_GOON_COUNT: int = 3
const GOONS_PER_ROUND: int = 1
const MAX_GOONS: int = 12

enum Phase { IDLE, COMBAT, UPGRADE }

var current_phase: Phase = Phase.IDLE
var round_number: int = 0

var _hero: EntityBase
var _live_goons: Array[EntityBase] = []
var _goon_parent: Node2D
var _spawn_point_nodes: Array[Marker2D] = []
var _chosen_upgrades: Array[UpgradeDefinition] = []
var _lab_menu_instance: LabMenu = null
var _transition: RoundTransition = null
var _enrage_stacks: int = 0
var _upgrade_database: UpgradeDatabase
var _round_timer: Timer


func initialise(hero: EntityBase) -> void:
	_hero = hero
	MutiePointsManager.register_hero(hero.health)
	_goon_parent = get_node(goon_container)
	for path in spawn_points:
		_spawn_point_nodes.append(get_node(path))
	_upgrade_database = DefaultUpgradeDatabase.new()
	_round_timer = Timer.new()
	_round_timer.one_shot = true
	_round_timer.timeout.connect(_on_timer_timeout)
	add_child(_round_timer)
	_transition = ROUND_TRANSITION_SCENE.instantiate()
	add_child(_transition)
	_start_round()


func _start_round() -> void:
	round_number += 1
	current_phase = Phase.COMBAT
	_enrage_stacks = 0
	_live_goons.clear()
	if _hero:
		_hero.process_mode = Node.PROCESS_MODE_INHERIT
	var count := mini(BASE_GOON_COUNT + (round_number - 1) * GOONS_PER_ROUND, MAX_GOONS)
	_spawn_goons(count)
	_round_timer.wait_time = round_time_limit
	_round_timer.start()
	round_started.emit(round_number)


func _spawn_goons(count: int) -> void:
	var points := _spawn_point_nodes.duplicate()
	points.shuffle()
	var round_bonus: float = (round_number - 1) * 0.15
	for i in count:
		var goon: EntityBase = GOON_SCENE.instantiate()
		_goon_parent.add_child(goon)
		if round_bonus > 0.0:
			_apply_round_scaling(goon, round_bonus)
		goon.global_position = points[i % points.size()].global_position
		for upgrade in _chosen_upgrades:
			upgrade.apply_to(goon)
		goon.health.on_death.connect(_on_goon_died.bind(goon))
		_live_goons.append(goon)


func _apply_round_scaling(goon: EntityBase, bonus: float) -> void:
	if not goon.modifiers:
		return
	var hp_mod := AttributeModifierBase.new()
	hp_mod.affected_attributes = [AttributeNames.HEALTH]
	hp_mod.modifier_type = AttributeModifierBase.ModifierType.ADDITIVE_PERCENT
	hp_mod.magnitude = bonus
	hp_mod.applicability = AttributeModifierBase.ModifierApplicability.ALWAYS
	hp_mod.duration = INF
	goon.modifiers.apply_modifier(hp_mod)

	var dmg_mod := AttributeModifierBase.new()
	dmg_mod.affected_attributes = [AttributeNames.MELEE_ATTACK_DAMAGE]
	dmg_mod.modifier_type = AttributeModifierBase.ModifierType.ADDITIVE_PERCENT
	dmg_mod.magnitude = bonus
	dmg_mod.applicability = AttributeModifierBase.ModifierApplicability.ALWAYS
	dmg_mod.duration = INF
	goon.modifiers.apply_modifier(dmg_mod)


func _on_goon_died(goon: EntityBase) -> void:
	_live_goons.erase(goon)
	if _live_goons.is_empty() and current_phase == Phase.COMBAT:
		_end_round()


func _end_round() -> void:
	_round_timer.stop()
	current_phase = Phase.UPGRADE
	round_ended.emit(round_number)
	if _hero:
		_hero.process_mode = Node.PROCESS_MODE_DISABLED
	await _transition.play_round_end(round_number)
	_open_lab_menu()
	await _transition.fade_in()


func _open_lab_menu() -> void:
	_lab_menu_instance = LAB_MENU_SCENE.instantiate()
	_lab_menu_instance.upgrade_database = _upgrade_database
	get_node("../UILayer").add_child(_lab_menu_instance)
	_lab_menu_instance.upgrade_chosen.connect(_on_upgrade_chosen)


func _on_upgrade_chosen(definition: UpgradeDefinition) -> void:
	_chosen_upgrades.append(definition)
	await _transition.fade_out()
	_close_lab_menu()
	_start_round()
	await _transition.fade_in()


func _close_lab_menu() -> void:
	if _lab_menu_instance:
		_lab_menu_instance.queue_free()
		_lab_menu_instance = null


func _on_timer_timeout() -> void:
	if current_phase != Phase.COMBAT:
		return
	_enrage_stacks += 1
	_apply_enrage(_hero)
	hero_enraged.emit(_enrage_stacks)
	_round_timer.start()


func _apply_enrage(entity: EntityBase) -> void:
	if not entity or not entity.modifiers:
		return
	var dmg_mod := AttributeModifierBase.new()
	dmg_mod.affected_attributes = [AttributeNames.MELEE_ATTACK_DAMAGE]
	dmg_mod.modifier_type = AttributeModifierBase.ModifierType.ADDITIVE_PERCENT
	dmg_mod.magnitude = enrage_damage_bonus
	dmg_mod.applicability = AttributeModifierBase.ModifierApplicability.ALWAYS
	dmg_mod.duration = INF
	entity.modifiers.apply_modifier(dmg_mod)

	var spd_mod := AttributeModifierBase.new()
	spd_mod.affected_attributes = [AttributeNames.MOVE_SPEED]
	spd_mod.modifier_type = AttributeModifierBase.ModifierType.ADDITIVE_PERCENT
	spd_mod.magnitude = enrage_speed_bonus
	spd_mod.applicability = AttributeModifierBase.ModifierApplicability.ALWAYS
	spd_mod.duration = INF
	entity.modifiers.apply_modifier(spd_mod)