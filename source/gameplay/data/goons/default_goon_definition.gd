class_name DefaultGoonDefinition
extends GoonDefinition

const GOON_SCENE: PackedScene = preload("res://source/entities/goon/goon.tscn")
const GOON_ICON: Texture2D = preload("res://assets/art/goon/idle.png")

func _init() -> void:
	display_name = "Goon"
	base_entity = GOON_SCENE
	icon = GOON_ICON
