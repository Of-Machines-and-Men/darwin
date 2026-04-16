class_name SpawnManager
extends Node

const CLUSTER_MIN: int = 4
const CLUSTER_MAX: int = 5
const CLUSTER_SPREAD: float = 50.0

const BASE_SPAWN_USES: int = 5

signal spawns_depleted
signal entity_spawned(entity: EntityBase)
signal remaining_spawns_changed(count: int)

var remaining_spawns: int = BASE_SPAWN_USES

var _spawn_toolbar: SpawnToolbar
var _gameplay_layer: Node

func setup(toolbar: SpawnToolbar, gameplay_layer: Node) -> void:
	_spawn_toolbar = toolbar
	_gameplay_layer = gameplay_layer

func reset() -> void:
	remaining_spawns = BASE_SPAWN_USES
	remaining_spawns_changed.emit(remaining_spawns)

func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	var mb := event as InputEventMouseButton
	if not mb.pressed or mb.button_index != MOUSE_BUTTON_LEFT:
		return
	if not _spawn_toolbar or not _spawn_toolbar.selected_definition:
		return
	if remaining_spawns <= 0:
		return
	_spawn_cluster(_spawn_toolbar.selected_definition, mb.global_position)

func _spawn_cluster(definition: GoonDefinition, center: Vector2) -> void:
	var count := randi_range(CLUSTER_MIN, CLUSTER_MAX)
	for i in count:
		var goon: EntityBase = definition.base_entity.instantiate()
		_gameplay_layer.add_child(goon)
		var offset := Vector2.from_angle(randf() * TAU) * randf_range(0.0, CLUSTER_SPREAD)
		goon.global_position = center + offset
		definition.configure_entity(goon)
		entity_spawned.emit(goon)
	remaining_spawns -= 1
	remaining_spawns_changed.emit(remaining_spawns)
	if remaining_spawns <= 0:
		spawns_depleted.emit()
