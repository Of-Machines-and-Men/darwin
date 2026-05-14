extends Control

@onready var timer_label: Label = $TimerLabel

var current_timer_value: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_timer_change(GameManager.round_timer)
	GameManager.on_timer_tick.connect(_on_timer_change)

func _on_timer_change(new_timer_value: float) -> void:
	current_timer_value = max(new_timer_value, 0.0)
	timer_label.text = "%05.2f" % current_timer_value
