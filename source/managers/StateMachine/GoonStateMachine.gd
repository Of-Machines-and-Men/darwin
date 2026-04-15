class_name GoonStateMachine
extends StateMachine

const IDLE_TEX: Texture2D = preload("res://assets/art/goon/idle.png")
const MOVE_TEX: Texture2D = preload("res://assets/art/goon/move.png")
const ATTACK_TEX: Texture2D = preload("res://assets/art/goon/attack.png")
const HURT_TEX: Texture2D = preload("res://assets/art/goon/hurt.png")

@onready var sprite: Sprite2D = $"../Sprite2D"

func _ready() -> void:
	current_state = IdleState.new()

func play(texture: Texture2D) -> void:
	sprite.texture = texture
