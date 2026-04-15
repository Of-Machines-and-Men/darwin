class_name SpawnToolbarPanel
extends Button

@onready var cost_label: Label = $MarginContainer/VBoxContainer/Cost
@onready var name_label: Label = $MarginContainer/VBoxContainer/Name
@onready var icon_container: TextureRect = $MarginContainer/Icon

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
