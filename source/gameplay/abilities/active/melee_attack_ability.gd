class_name AttackAbility
extends AbilityBase

@export var projectile_scene: PackedScene
@export var base_cooldown: float = 1.0

var _cooldown_timer: float = 0.0

func tick(caller: EntityBase, delta_time: float) -> void:
	_cooldown_timer = maxf(0.0, _cooldown_timer - delta_time)
	super.tick(caller, delta_time)

func _can_activate(caller: EntityBase) -> bool:
	var target = get_current_target(caller)
	if _cooldown_timer > 0.0 or target:
		return false
	var attack_range = get_effective_ability_value(AttributeNames.MELEE_RANGE, caller, INF)
	if target and attack_range < INF:
		return caller.global_position.distance_to(target.global_position) <= attack_range
	return true

func _on_activated(caller: EntityBase) -> void:
	super._on_activated(caller)
	_cooldown_timer = base_cooldown
	var projectile_instance = _build_projectile(caller)
	if projectile_instance:
		_spawn_projectile(caller, projectile_instance)

func _build_projectile(caller: EntityBase) -> ProjectileBase:
	if not projectile_scene:
		push_warning("AttackAbility: no projectile_scene assigned")
		return null
	var projectile_instance = projectile_scene.instantiate() as ProjectileBase
	if not projectile_instance:
		push_warning("AttackAbility: projectile_scene is not a ProjectileBase")
		return null
	projectile_instance.on_hit.connect(_on_projectile_hit)
	projectile_instance.initialise(caller, get_current_target(caller), get_resolved_values(caller))
	return projectile_instance

func _spawn_projectile(caller: EntityBase, projectile_instance: ProjectileBase) -> void:
	caller.get_parent().add_child(projectile_instance)

func _on_projectile_hit(target: EntityBase, damage: float, _tags: Array[StringName]) -> void:
	print("Hit %s for %s damage" % [target.name, damage])
