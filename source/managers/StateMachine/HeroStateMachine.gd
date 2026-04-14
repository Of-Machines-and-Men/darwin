class_name HeroStateMachine
extends StateMachine

const IDLE_TEX: Texture2D = preload("res://assets/art/hero/heroIdle.png")
const MOVE_TEX: Texture2D = preload("res://assets/art/hero/heroMove.png")
const BACKWARD_TEX: Texture2D = preload("res://assets/art/hero/heroBackward.png")
const LIGHTJAB_TEX: Texture2D = preload("res://assets/art/hero/heroLightjab.png")
const SUPERPUNCH1_TEX: Texture2D = preload("res://assets/art/hero/heroSuperpunch1.png")
const SUPERPUNCH2_TEX: Texture2D = preload("res://assets/art/hero/heroSuperpunch2.png")
const HURT_TEX: Texture2D = preload("res://assets/art/hero/heroPain.png")
const DEAD_TEX: Texture2D = preload("res://assets/art/hero/heroDead.png")
const DEAD2_TEX: Texture2D = preload("res://assets/art/hero/heroDead2.png")

@onready var sprite: Sprite2D = $"../Sprite2D"

func _ready() -> void:
	current_state = IdleState.new()

func play(texture: Texture2D) -> void:
	sprite.texture = texture
