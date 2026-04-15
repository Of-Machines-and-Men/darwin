extends Node2D

const LAB_MENU_SCENE: PackedScene = preload("res://source/scenes/UI/LabMenu.tscn")
const ROUND_DURATION: float = 40.0

@onready var hero: EntityBase = $GameplayLayer/Hero
@onready var gameplay_layer: Node = $GameplayLayer
@onready var ui_layer: CanvasLayer = $UILayer
@onready var round_timer_label: Label = $UILayer/RoundTimer
@onready var spawns_label: Label = $UILayer/SpawnsLabel
@onready var spawn_toolbar: SpawnToolbar = $UILayer/SpawnToolbar
@onready var spawn_manager: SpawnManager = $SpawnManager
@onready var health_bar: HealthBar = $UILayer/HealthBar

var _lab_menu: LabMenu = null
var _upgrade_database: UpgradeDatabase
var _chosen_upgrades: Array[UpgradeDefinition] = []
var _round_time_remaining: float = ROUND_DURATION
var _round_active: bool = false
var _live_goons: Array[EntityBase] = []
var _all_goons: Array[EntityBase] = []

func _ready() -> void:
	_upgrade_database = DefaultUpgradeDatabase.new()
	MutiePointsManager.register_hero(hero.health)
	spawn_toolbar.definitions = [DefaultGoonDefinition.new()]
	spawn_toolbar.populate_slots()
	spawn_manager.setup(spawn_toolbar, gameplay_layer)
	spawn_manager.spawns_depleted.connect(_on_spawns_depleted)
	spawn_manager.entity_spawned.connect(_on_entity_spawned)
	health_bar.setup(hero.health)
	_start_round()

func _process(delta: float) -> void:
	if not _round_active:
		return
	_round_time_remaining = maxf(_round_time_remaining - delta, 0.0)
	_update_timer_label()
	_update_spawns_label()
	if _round_time_remaining <= 0.0:
		_end_round()

func _update_timer_label() -> void:
	var total_seconds := ceili(_round_time_remaining)
	round_timer_label.text = "%d:%02d" % [total_seconds / 60, total_seconds % 60]

func _update_spawns_label() -> void:
	spawns_label.text = "Spawns: %d" % spawn_manager.remaining_spawns

func _on_entity_spawned(entity: EntityBase) -> void:
	for upgrade in _chosen_upgrades:
		upgrade.apply_to(entity)
	_live_goons.append(entity)
	_all_goons.append(entity)
	entity.health.on_death.connect(_on_goon_died.bind(entity))

func _on_goon_died(goon: EntityBase) -> void:
	_live_goons.erase(goon)
	if _live_goons.is_empty() and spawn_manager.remaining_spawns <= 0:
		_end_round()

func _on_spawns_depleted() -> void:
	if _live_goons.is_empty():
		_end_round()

func _end_round() -> void:
	if not _round_active:
		return
	_round_active = false
	hero.process_mode = Node.PROCESS_MODE_DISABLED
	spawn_manager.process_mode = Node.PROCESS_MODE_DISABLED
	_clear_goons()
	health_bar.hide()
	_open_lab_menu()

func _clear_goons() -> void:
	for goon in _all_goons:
		if is_instance_valid(goon):
			goon.queue_free()
	_all_goons.clear()
	_live_goons.clear()

func _open_lab_menu() -> void:
	_lab_menu = LAB_MENU_SCENE.instantiate()
	_lab_menu.upgrade_database = _upgrade_database
	ui_layer.add_child(_lab_menu)
	_lab_menu.upgrade_chosen.connect(_on_upgrade_chosen)

func _on_upgrade_chosen(definition: UpgradeDefinition) -> void:
	_chosen_upgrades.append(definition)
	if _lab_menu:
		_lab_menu.queue_free()
		_lab_menu = null
	hero.process_mode = Node.PROCESS_MODE_INHERIT
	_start_round()

func _start_round() -> void:
	_live_goons.clear()
	_all_goons.clear()
	_round_time_remaining = ROUND_DURATION
	_round_active = true
	spawn_manager.reset()
	spawn_manager.process_mode = Node.PROCESS_MODE_INHERIT
	hero.health.heal_damage(hero.health.health_attribute.get_effective_value())
	health_bar.show()
	_update_timer_label()
	_update_spawns_label()
