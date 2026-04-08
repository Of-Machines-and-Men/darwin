class_name BehaviourComponent
extends ComponentBase

@export var vision_zone: Area2D
@export var attributes: AttributeSet
@export var behaviours: Array[BehaviourBase] = []
@export var decision_delay: float = 1.0

var _targets: Array[EntityBase] = []
var current_target: EntityBase

var _decision_timer: float = decision_delay
var _current_behaviour: BehaviourBase

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	if vision_zone:
		vision_zone.body_entered.connect(_on_perceive)
		vision_zone.body_exited.connect(_on_unperceive)

func _get_valid_behaviour() -> BehaviourBase:
	var last_priority: int = -1
	var selected_behaviour: BehaviourBase
	for behaviour in behaviours:
		if behaviour.priority > last_priority and behaviour.can_activate(_parent):
			last_priority = behaviour.priority
			selected_behaviour = behaviour
	return selected_behaviour

func _set_current_behaviour(behaviour: BehaviourBase) -> void:
	if _current_behaviour == behaviour:
		return
	if _current_behaviour:
		_current_behaviour.deactivate(_parent)
	if behaviour:
		behaviour.activate(_parent)
	_current_behaviour = behaviour

func _think() -> void:
	current_target = get_nearest_hostile_target()
	var behaviour = _get_valid_behaviour()
	_set_current_behaviour(behaviour)

func _on_perceive(perceived: Node2D) -> void:
	if perceived is EntityBase:
		_targets.append(perceived)
	
func _on_unperceive(unperceived: Node2D) -> void:
	if unperceived is EntityBase:
		_targets.erase(unperceived)

func get_nearest_hostile_target() -> EntityBase:
	var nearest_distance: float = INF
	var nearest_target: EntityBase
	for target in _targets:
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
	if _current_behaviour:
		_current_behaviour.tick(_parent, delta)
