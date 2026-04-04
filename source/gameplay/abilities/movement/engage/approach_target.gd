class_name ApproachTargetAbility
extends AbilityBase

@export var target_distance_threshold: float = 10.0
@export var default_speed: float = 100.0

func tick(caller: EntityBase, _delta_time: float) -> void:
	var move_speed = caller.attributes.get_value(&"MoveSpeed", default_speed)
	var destination = caller.get_current_destination()
	if caller.global_position.distance_to(destination) > target_distance_threshold:
		caller.velocity = (destination - caller.global_position).normalized() * move_speed
	else:
		caller.velocity = Vector2.ZERO
	
func can_activate(caller: EntityBase) -> bool:
	return caller.current_target != null
