class_name BehaviourComponent
extends ComponentBase

@export var vision_zone: Area2D
@export var behaviours: Array[BehaviourBase] = []
@export var decision_delay: float = 0.2
@export var navigation_agent: NavigationAgent2D

var _targets: Array[EntityBase] = []
var current_target: EntityBase

var _decision_timer: float = decision_delay
var _current_behaviour: BehaviourBase

signal on_target_acquired(target: EntityBase)
signal on_target_lost(target: EntityBase)
signal on_behaviour_changed(old_behaviour: BehaviourBase, new_behaviour: BehaviourBase)
signal on_change_current_target(old_target: EntityBase, new_target: EntityBase)
signal on_change_current_destination(old_destination: Vector2, new_destination: Vector2)

func _ready() -> void:
	super._ready()
	_decision_timer = decision_delay
	if vision_zone:
		vision_zone.body_entered.connect(_on_perceive)
		vision_zone.body_exited.connect(_on_unperceive)

func _get_valid_behaviour() -> BehaviourBase:
	var last_priority: int = -1
	var selected_behaviour: BehaviourBase
	for behaviour in behaviours:
		if behaviour.priority > last_priority and behaviour.can_activate(_parent, current_target):
			last_priority = behaviour.priority
			selected_behaviour = behaviour
	return selected_behaviour

func _set_current_behaviour() -> void:
	var behaviour = _get_valid_behaviour()
	if _current_behaviour != behaviour:
		on_behaviour_changed.emit(_current_behaviour, behaviour)
		if _current_behaviour:
			_current_behaviour.deactivate(_parent, current_target)
		_current_behaviour = behaviour
		if _current_behaviour:
			_current_behaviour.activate(_parent, current_target)
	
func _select_target() -> void:
	var new_target: EntityBase = get_nearest_hostile_target()
	if new_target != current_target:
		on_change_current_target.emit(current_target, new_target)
		current_target = new_target

func _build_navigation_path() -> void:
	if _current_behaviour:
		var new_destination = _current_behaviour.get_destination(_parent, current_target)
		if new_destination != navigation_agent.target_position:
			on_change_current_destination.emit(navigation_agent.target_position, new_destination)
			navigation_agent.target_position = new_destination
	else:
		navigation_agent.target_position = _parent.global_position

func _think() -> void:
	_select_target()
	_set_current_behaviour()
	_build_navigation_path()

func _on_perceive(perceived: Node2D) -> void:
	if perceived is EntityBase:
		on_target_acquired.emit(perceived)
		_targets.append(perceived)
		perceived.tree_exiting.connect(_on_target_freed.bind(perceived))
	
func _on_unperceive(unperceived: Node2D) -> void:
	if unperceived is EntityBase:
		on_target_lost.emit(unperceived)
		_targets.erase(unperceived)
		
func _on_target_freed(target: EntityBase) -> void:
	_targets.erase(target)
	if current_target == target:
		current_target = null
		_decision_timer = 0.0

func get_nearest_hostile_target() -> EntityBase:
	var nearest_distance: float = INF
	var nearest_target: EntityBase
	for target in _targets:
		if not is_instance_valid(target):
			continue
		var target_distance = _parent.global_position.distance_to(target.global_position)
		if target_distance < nearest_distance and FactionManager.is_hostile(_parent.faction, target.faction):
			nearest_distance = target_distance
			nearest_target = target
	return nearest_target

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	_decision_timer -= delta
	if _decision_timer <= 0.0:
		_think()
		_decision_timer = decision_delay
	if _current_behaviour:
		_current_behaviour.process(_parent, current_target, delta)
