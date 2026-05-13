class_name GoonSpawner
extends SpawnerBase

func _ready() -> void:
	SpawnManager.register_goon_spawner(self)
