class_name GoonStateMachine
extends StateMachine

const KNOCKBACK_FORCE: float = 400.0

@onready var sprite: Sprite2D = $"../Sprite2D"
@onready var _entity: EntityBase = $".."
@onready var _nav_agent: NavigationAgent2D = $"../NavigationAgent2D"
@onready var _ability_component: AbilityComponent = $"../AbilityComponent"

var _pending_death: bool = false
var _knockback_velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	super._ready()
	if _entity.health:
		_entity.health.on_damaged.connect(_on_damaged)
		_entity.health.on_death.connect(_on_death_received)
	for ability in _ability_component.abilities:
		ability.on_activate_ability.connect(_on_ability_activated)
	transition_to("idle")

func _process(delta: float) -> void:
	super._process(delta)
	if current_state is IdleState:
		if _pending_death:
			_pending_death = false
			transition_to("death")
			_entity.set_collision_layer(0)
			_entity.set_collision_mask(0)
			_entity.get_parent().move_child(_entity, 0)
			_entity.process_mode = Node.PROCESS_MODE_DISABLED
		elif is_moving():
			transition_to("walk")
	elif current_state is WalkState and not is_moving():
		transition_to("idle")

func _physics_process(delta: float) -> void:
	if current_state is HurtState:
		_knockback_velocity = _knockback_velocity.lerp(Vector2.ZERO, delta * 10.0)
		_entity.velocity = _knockback_velocity

func play(texture: Texture2D) -> void:
	sprite.texture = texture

func is_moving() -> bool:
	return not _nav_agent.is_navigation_finished() and _entity.velocity != Vector2.ZERO

func _apply_knockback() -> void:
	if not _entity.behaviour or not _entity.behaviour.current_target:
		_knockback_velocity = Vector2.ZERO
		return
	var direction := (_entity.global_position - _entity.behaviour.current_target.global_position).normalized()
	_knockback_velocity = direction * KNOCKBACK_FORCE

func _on_damaged(_amount: float, _remaining: float, _tags: Array[StringName]) -> void:
	if not current_state is DeathState:
		_apply_knockback()
		transition_to("hurt")

func _on_death_received() -> void:
	_pending_death = true

func _on_ability_activated(_ability: AbilityBase) -> void:
	if not current_state is DeathState and not current_state is HurtState:
		transition_to("attack")
