extends Node2D

const GOON_SCENE: PackedScene = preload("res://source/entities/goon/goon.tscn")
const LAB_MENU_SCENE: PackedScene = preload("res://source/scenes/UI/LabMenu.tscn")

@onready var hero: EntityBase = $GameplayLayer/Hero
@onready var gameplay_layer: Node = $GameplayLayer
@onready var ui_layer: CanvasLayer = $UILayer
@onready var spawn_points: Node2D = $GameplayLayer/SpawnPoints

var _live_goons: Array[EntityBase] = []
var _lab_menu: LabMenu = null
var _upgrade_database: UpgradeDatabase
var _chosen_upgrades: Array[UpgradeDefinition] = []

func _ready() -> void:
	_upgrade_database = DefaultUpgradeDatabase.new()
	MutiePointsManager.register_hero(hero.health)
	_spawn_round()

func _track_goon(goon: EntityBase) -> void:
	_live_goons.append(goon)
	goon.health.on_death.connect(_on_goon_died.bind(goon))

func _on_goon_died(goon: EntityBase) -> void:
	_live_goons.erase(goon)
	if _live_goons.is_empty():
		_end_round()

func _end_round() -> void:
	hero.process_mode = Node.PROCESS_MODE_DISABLED
	_open_lab_menu()

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
	_spawn_round()

func _spawn_round() -> void:
	_live_goons.clear()
	for point in spawn_points.get_children():
		var goon: EntityBase = GOON_SCENE.instantiate()
		gameplay_layer.add_child(goon)
		goon.global_position = point.global_position
		for upgrade in _chosen_upgrades:
			upgrade.apply_to(goon)
		_track_goon(goon)
