class_name AttackAbility
extends AbilityBase

@export var projectile_scene: PackedScene
@export var base_cooldown: float = 1.0

var _cooldown_timer: float = base_cooldown

func tick(caller: EntityBase, delta_time: float) -> void:
	_cooldown_timer -= delta_time
	super.tick(caller, delta_time)
	
func _can_activate(_caller: EntityBase) -> bool:
	return _cooldown_timer <= 0.0

func _on_activated(caller: EntityBase) -> void:
	super._on_activated(caller)
	_cooldown_timer = base_cooldown
	var projectile_instance = _build_projectile(caller)
	if projectile_instance:
		_spawn_projectile(caller, projectile_instance)

func _build_projectile(caller: EntityBase) -> ProjectileBase:
	var projectile_instance = projectile_scene.instantiate() as ProjectileBase
	if not projectile_instance:
		push_warning("AttackAbility: projectile scene is not a ProjectileBase")
		return null
	projectile_instance.initialise(caller, [])
	return projectile_instance

func _spawn_projectile(caller: EntityBase, projectile_instance: ProjectileBase) -> void:
	var world = caller.get_parent()
	world.add_child(projectile_instance)
