class_name ComponentBase
extends Node

var _parent: EntityBase

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_parent = get_parent() as EntityBase

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
