class_name SpawnToolbar
extends Control

@export var definitions: Array[GoonDefinition] = []
@export var hotbar_slots_container: Container

var selected_definition: GoonDefinition = null
var hotbar_slots: Array[SpawnToolbarPanel] = []

signal on_definition_selected(definition: GoonDefinition)

func _ready() -> void:
	for slot in hotbar_slots:
		slot.on_pressed.connect(_on_slot_pressed)
	
func _on_slot_pressed(definition: GoonDefinition) -> void:
	selected_definition = definition
	on_definition_selected.emit(definition)
