class_name EntityBase
extends CharacterBody2D

@export var vision_zone: Area2D
@export var hearing_zone: Area2D

@export var attributes: AttributeSet

@export var movement_abilities: Array[AbilityBase] = []
@export var combat_abilities: Array[AbilityBase] = []
@export var support_abilities: Array[AbilityBase] = []

func _physics_process(delta: float) -> void:
	move_and_slide()
