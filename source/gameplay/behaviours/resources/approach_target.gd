class_name ApproachTarget
extends BehaviourBase

func get_destination(_caller: EntityBase, _target: EntityBase) -> Vector2:
	if _target:
		return _target.global_position
	else:
		return _caller.global_position
	
	
func can_activate(_caller: EntityBase, _target: EntityBase) -> bool:
	return _target != null
