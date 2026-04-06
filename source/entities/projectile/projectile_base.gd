class_name ProjectileBase
extends Node2D

@export var impact_zone: Area2D

func initialise(_spawning_entity: EntityBase, _attributes: Array[AttributeBase]) -> void:
	pass

func _ready() -> void:
	# connect on_overlap events
	pass
