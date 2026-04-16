class_name HeroStateMachine
extends StateMachine

@onready var sprite: Sprite2D = $"../Sprite2D"
@onready var _entity: EntityBase = $".."
@onready var _nav_agent: NavigationAgent2D = $"../NavigationAgent2D"
@onready var _ability_component: AbilityComponent = $"../AbilityComponent"

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
	if current_state is IdleState and is_moving():
		transition_to("walk")
	elif current_state is WalkState and not is_moving():
		transition_to("idle")

func play(texture: Texture2D) -> void:
	sprite.texture = texture

func is_moving() -> bool:
	return not _nav_agent.is_navigation_finished() and _entity.velocity != Vector2.ZERO

func _on_damaged(_amount: float, _remaining: float, _tags: Array[StringName]) -> void:
	if not current_state is DeathState:
		transition_to("hurt")

func _on_death_received() -> void:
	transition_to("death")

func _on_ability_activated(_ability: AbilityBase) -> void:
	if not current_state is DeathState and not current_state is HurtState:
		transition_to("attack")
