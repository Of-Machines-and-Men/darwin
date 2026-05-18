extends Node

var goon_spawners: Array[GoonSpawner] = []
var hero_spawners: Array[HeroSpawner] = []

var _last_goon_spawner_index: int = -1
var _last_hero_spawner_index: int = -1

func spawn_hero(hero_definition: GoonDefinition) -> void:
	_last_hero_spawner_index = _get_next_hero_spawner_index()
	var spawner = hero_spawners[_last_hero_spawner_index]
	pass

func spawn_goon(goon_definition: GoonDefinition) -> void:
	if goon_spawners.is_empty() or goon_definition == null:
		push_error("No goon spawners registered in SpawnManager.")
		return

	_last_goon_spawner_index = _get_next_goon_spawner_index()
	var spawner = goon_spawners[_last_goon_spawner_index]
	
	if not goon_definition.base_entity:
		push_error("GoonDefinition %s does not have a valid base_entity." % goon_definition.display_name)
		return
	
	var goon = goon_definition.base_entity.instantiate() as EntityBase
	if not goon:
		push_error("Failed to instantiate goon from definition %s." % goon_definition.display_name)
		return
	
	goon_definition.configure_entity(goon)

	# Add goon to the scene tree and position it at the spawner
	spawner.get_parent().add_child(goon)
	goon.global_position = spawner.global_position


func clear_spawners() -> void:
	hero_spawners = []
	goon_spawners = []

func register_hero_spawner(spawner: HeroSpawner) -> void:
	if not spawner in hero_spawners:
		hero_spawners.append(spawner)

func register_goon_spawner(spawner: GoonSpawner) -> void:
	if not spawner in goon_spawners:
		goon_spawners.append(spawner)
	
func _get_next_hero_spawner_index() -> int:
	var index = _last_hero_spawner_index + 1
	return wrapi(index, 0, hero_spawners.size())

func _get_next_goon_spawner_index() -> int:
	var index = _last_goon_spawner_index + 1
	return wrapi(index, 0, goon_spawners.size())
