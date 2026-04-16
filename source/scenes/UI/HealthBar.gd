class_name HealthBar
extends Control

@onready var _fill_rect: ColorRect = $TextureRect/FillRect
@onready var _flash_rect: ColorRect = $TextureRect/FlashRect

var _max_hp: float = 1.0

func _ready() -> void:
	_flash_rect.color = Color(1, 1, 1, 0)
	_fill_rect.color = Color(0.2, 0.85, 0.2)

func setup(health: HealthComponent) -> void:
	_max_hp = health.health_attribute.get_effective_value()
	_update_fill(health.health_attribute.get_current_value())
	health.on_damaged.connect(_on_damaged)
	health.on_restored.connect(_on_restored)

func _on_damaged(_amount: float, remaining: float, _tags: Array[StringName]) -> void:
	_update_fill(remaining)

func _on_restored(_amount: float, remaining: float, _tags: Array[StringName]) -> void:
	_update_fill(remaining)

func _update_fill(current: float) -> void:
	_fill_rect.anchor_right = clampf(current / _max_hp, 0.0, 1.0)
