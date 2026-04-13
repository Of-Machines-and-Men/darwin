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
	_last_goon_spawner_index = _get_next_goon_spawner_index()
	var spawner = goon_spawners[_last_goon_spawner_index]
	pass

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
