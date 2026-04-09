extends Control

@export var max_health: float = 100.0
@export var segment_count: int = 10
@export var flash_color: Color = Color(1, 0.2, 0.2, 0.6)
@export var fill_color: Color = Color(0.8, 0.1, 0.1, 1.0)
@export var low_health_color: Color = Color(0.5, 0.0, 0.0, 1.0)
@export var low_health_threshold: float = 0.25

var current_health: float = 100.0
var _tween: Tween

@onready var fill_rect: ColorRect = $FillRect
@onready var flash_rect: ColorRect = $FlashRect
@onready var bg_rect: ColorRect = $BgRect

func _ready() -> void:
	flash_rect.color = Color(0, 0, 0, 0)
	set_health(max_health)

func set_health(new_health: float) -> void:
	var old_health = current_health
	current_health = clamp(new_health, 0.0, max_health)

	var pct = current_health / max_health

	fill_rect.size.x = size.x * pct

	fill_rect.color = fill_color.lerp(low_health_color,
		1.0 - smoothstep(low_health_threshold, low_health_threshold + 0.1, pct))

	if new_health < old_health:
		_trigger_flash()

func _trigger_flash() -> void:
	if _tween:
		_tween.kill()
	flash_rect.color = flash_color
	_tween = create_tween()
	_tween.tween_property(flash_rect, "color:a", 0.0, 0.3)\
		  .set_ease(Tween.EASE_OUT)
