class_name EntityBase
extends CharacterBody2D

@export var modifiers: ModifiersComponent
@export var health: HealthComponent
@export var behaviour: BehaviourComponent
@export var faction: FactionManager.Faction

@export var threat_rating: float = 0.0

func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	move_and_slide()

func apply_damage(amount: float, tags: Array[StringName] = []) -> void:
	if health:
		health.apply_damage(amount, tags)
