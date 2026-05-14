extends Control

@onready var points_count: Label = $HBoxContainer/PointsCount
var current_points: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_points_changed(PlayerManager.points)
	PlayerManager.on_points_changed.connect(_on_points_changed)
	
func _on_points_changed(new_points: int) -> void:
	current_points = max(new_points, 0)
	points_count.text = "%04d" % new_points
