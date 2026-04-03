class_name EntityBase
extends CharacterBody2D

@export var vision_zone: Area2D
@export var hearing_zone: Area2D

@export var attributes: AttributeSet
@export var faction: FactionManager.Faction

@export var movement_abilities: Array[AbilityBase] = []
@export var active_abilities: Array[AbilityBase] = []
@export var passive_abilities: Array[AbilityBase] = []

@export var base_decision_delay: float = 1.0

# we should be able to make a decision on spawn instead of delaying initially
var _thinking_timer: float = 0.0

var _current_movement_ability: AbilityBase = null
var _current_active_abilities: Array[AbilityBase] = []

var current_target: EntityBase
var current_destination: Vector2 = Vector2.ZERO
var _visible_targets: Array[Node] = []
var _audible_targets: Array[Node] = []

func _ready() -> void:
	if vision_zone:
		vision_zone.body_entered.connect(_perceive_visual)
		vision_zone.body_exited.connect(_lost_visual)
	
	if hearing_zone:
		hearing_zone.body_entered.connect(_perceive_audible)
		hearing_zone.body_exited.connect(_lost_audible)
		
	current_destination = self.global_position

func _physics_process(delta: float) -> void:
	_thinking_timer -= delta
	if (_thinking_timer <= 0.0):
		_think()
		_thinking_timer = base_decision_delay
	
	_act(delta)
	move_and_slide()

func _perceive_audible(detected_target: Node) -> void:
	pass
	
func _perceive_visual(detected_target: Node) -> void:
	pass
	
func _lost_audible(lost_target: Node) -> void:
	pass
	
func _lost_visual(lost_target: Node) -> void:
	pass
	
func _think() -> void:
	pass
	
func _act(delta_time: float) -> void:
	if _current_movement_ability:
		_current_movement_ability.tick(self, delta_time)
	
	if _current_active_abilities.size():
		for ability in _current_active_abilities:
			ability.tick(self, delta_time)
	
	if passive_abilities.size():
		for ability in passive_abilities:
			ability.tick(self, delta_time)
	
