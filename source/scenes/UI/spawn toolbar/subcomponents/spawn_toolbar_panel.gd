class_name SpawnToolbarPanel
extends Button

@export var cost_label: Label
@export var name_label: Label
@export var icon_container: TextureRect

signal on_pressed(definition: GoonDefinition)

var value: GoonDefinition = null

func set_value(new_value: GoonDefinition) -> void:
	value = new_value
	disabled = false
	icon_container.texture = new_value.icon
	cost_label.text = str(new_value.get_effective_spawn_cost())
	name_label.text = new_value.display_name

func _handle_pressed() -> void:
	if value:
		on_pressed.emit(value)

func _ready() -> void:
	pressed.connect(_handle_pressed)
