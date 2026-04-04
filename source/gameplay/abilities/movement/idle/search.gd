class_name SearchAbility
extends AbilityBase

@export var search_distance_threshold: float = 10.0
@export var search_radius: float = 500.0
@export var default_speed: float = 75.0
@export var wander_timeout: float = 5.0

var _wander_timer: float = wander_timeout
var _current_destination: Vector2

func _set_random_destination(current_location: Vector2) -> void:
	var direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
	_current_destination = current_location + direction * randf_range(search_distance_threshold, search_radius)

func tick(caller: EntityBase, delta_time: float) -> void:
	var move_speed = caller.attributes.get_value(&"MoveSpeed", default_speed)
	_wander_timer -= delta_time
	if _wander_timer <= 0.0 or caller.global_position.distance_to(_current_destination) <= search_distance_threshold:
		_wander_timer = wander_timeout
		_set_random_destination(caller.global_position)
	caller.velocity = (_current_destination - caller.global_position).normalized() * move_speed

func on_activated(caller: EntityBase) -> void:
	_set_random_destination(caller.global_position)

func can_activate(_caller: EntityBase) -> bool:
	return true
