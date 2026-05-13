class_name HeroSpawner
extends SpawnerBase

func _ready() -> void:
	SpawnManager.register_hero_spawner(self)
