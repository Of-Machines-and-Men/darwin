extends Node2D

@onready var hero: EntityBase = $GameplayLayer/Hero
@onready var round_manager: RoundManager = $RoundManager

func _ready() -> void:
	round_manager.initialise(hero)
