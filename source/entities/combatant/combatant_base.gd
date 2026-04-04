class_name CombatantBase
extends EntityBase

var _last_heard_position: Vector2
var _last_seen_position: Vector2

var _visible_targets: Array[EntityBase] = []
var _audible_targets: Array[EntityBase] = []

func _ready():
	super._ready()

func _perceive_audible(detected_target: Node) -> void:
	if detected_target is EntityBase and detected_target != self:
		_audible_targets.append(detected_target)
		if not current_target:
			_trigger_decision()
	
func _perceive_visual(detected_target: Node) -> void:
	if detected_target is EntityBase and detected_target != self:
		_visible_targets.append(detected_target)
		if not current_target:
			_trigger_decision()
	
func _lost_audible(lost_target: Node) -> void:
	if lost_target is EntityBase:
		_audible_targets.erase(lost_target)
		_last_heard_position = lost_target.global_position
		_trigger_decision()
	
func _lost_visual(lost_target: Node) -> void:
	if lost_target is EntityBase:
		_visible_targets.erase(lost_target)
		_last_seen_position = lost_target.global_position
		if lost_target == current_target:
			current_target = null
		_trigger_decision()

func _get_known_hostile_targets() -> Array[EntityBase]:
	var hostile_targets: Array[EntityBase] = []
	for candidate in _visible_targets:
		if FactionManager.is_hostile(self.faction, candidate.faction):
			hostile_targets.append(candidate)
	return hostile_targets

func _get_nearest_entity(candidates: Array[EntityBase]) -> EntityBase:
	var nearest_distance: float = INF
	var nearest_entity: EntityBase
	for candidate in candidates:
		var target_distance: float = self.global_position.distance_to(candidate.global_position)
		if target_distance < nearest_distance:
			nearest_distance = target_distance
			nearest_entity = candidate
	return nearest_entity
	
func _update_current_target() -> void:
	var hostile_targets = _get_known_hostile_targets()
	current_target = _get_nearest_entity(hostile_targets)

func sort_abilities_by_priority(a: AbilityBase, b: AbilityBase):
	return a.priority > b.priority
	
func _think() -> void:
	_update_current_target()
	movement_abilities.sort_custom(sort_abilities_by_priority)
	for ability in movement_abilities:
		if ability.can_activate(self):
			_current_movement_ability = ability
			break
	
func _on_health_lost() -> void:
	pass
	
func _on_health_restored() -> void:
	pass
	
func _on_death() -> void:
	pass

func get_current_destination() -> Vector2:
	if current_target:
		return current_target.global_position
	elif _last_seen_position:
		return _last_seen_position
	elif _last_heard_position:
		return _last_heard_position
	else:
		return super.get_current_destination()
