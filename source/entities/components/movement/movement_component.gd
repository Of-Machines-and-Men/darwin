class_name MovementComponent
extends ComponentBase

@export var attributes: AttributeSet
@export var navigation_agent: NavigationAgent2D

var current_destination: Vector2
var movement_path

func _ready() -> void:
	# configure our navigation agent
	super._ready()

func _physics_process(_delta: float) -> void:
	var movement_speed_attribute = attributes.get_attribute(AttributeNames.MOVE_SPEED)

	if movement_speed_attribute and navigation_agent:
		if navigation_agent.is_navigation_finished():
			_parent.velocity = Vector2.ZERO
			return
		var destination = navigation_agent.get_next_path_position()
		var movement_speed_modifiers = _parent.modifiers.get_modifiers_for(AttributeNames.MOVE_SPEED)
		var movement_speed = movement_speed_attribute.get_effective_value(movement_speed_modifiers)
		var direction = (destination - _parent.global_position).normalized()
		_parent.velocity = direction * movement_speed
		
