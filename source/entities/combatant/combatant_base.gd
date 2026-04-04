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

func _get_valid_priority_ability(abilities: Array[AbilityBase]) -> AbilityBase:
	var last_priority = -INF
	var selected_ability
	for ability in abilities:
		if ability.can_activate(self) and ability.priority > last_priority:
			last_priority = ability.priority
			selected_ability = ability
	return selected_ability
	
func _set_movement_ability(ability: AbilityBase) -> void:
	if ability != _current_movement_ability:
		_current_movement_ability.on_deactivated(self)
		ability.on_activated(self)
		_current_movement_ability = ability
	
func _think() -> void:
	_update_current_target()
	_current_movement_ability = _get_valid_priority_ability(movement_abilities)
	
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
