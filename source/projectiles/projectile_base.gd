class_name ProjectileBase
extends Node2D

@export var impact_zone: Area2D
@export var speed: float = 0.0
@export var max_range: float = 50.0
@export var lifetime: float = 0.2

signal on_hit(target: EntityBase, damage: float, tags: Array[StringName])

var _spawner: EntityBase
var _direction: Vector2 = Vector2.ZERO
var _damage: float = 0.0
var _damage_tags: Array[StringName] = []
var _distance_travelled: float = 0.0
var _lifetime_timer: float = 0.0

func initialise(spawning_entity: EntityBase, target: EntityBase, resolved_values: Dictionary) -> void:
	_spawner = spawning_entity
	_damage = resolved_values.get(AttributeNames.BASE_MELEE_DAMAGE, 0.0)
	_lifetime_timer = lifetime
	if target:
		_direction = (target.global_position - spawning_entity.global_position).normalized()

func _ready() -> void:
	if _spawner:
		global_position = _spawner.global_position
	if impact_zone:
		impact_zone.body_entered.connect(_on_body_entered)
		# await one physics frame so the engine detects bodies already overlapping on spawn
		await get_tree().physics_frame
		if not is_queued_for_deletion():
			for body in impact_zone.get_overlapping_bodies():
				_on_body_entered(body)

func _physics_process(delta: float) -> void:
	_lifetime_timer -= delta
	if _lifetime_timer <= 0.0:
		queue_free()
		return

	if speed > 0.0:
		var movement = _direction * speed * delta
		global_position += movement
		_distance_travelled += movement.length()
		if _distance_travelled >= max_range:
			queue_free()

func _on_body_entered(body: Node) -> void:
	if body == _spawner:
		return
	if body is EntityBase:
		on_hit.emit(body as EntityBase, _damage, _damage_tags)
		queue_free()
