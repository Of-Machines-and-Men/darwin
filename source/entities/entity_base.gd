class_name EntityBase
extends CharacterBody2D

@export var modifiers: ModifiersComponent
@export var health: HealthComponent
@export var behaviour: BehaviourComponent
@export var abilities: AbilityComponent
@export var faction: FactionManager.Faction

@export var threat_rating: float = 0.0

func _on_death():
	pass

func _ready() -> void:
	if health:
		health.on_death.connect(_on_death)

func _physics_process(_delta: float) -> void:
	move_and_slide()

func apply_damage(amount: float, tags: Array[StringName] = []) -> void:
	if health:
		health.apply_damage(amount, tags)
