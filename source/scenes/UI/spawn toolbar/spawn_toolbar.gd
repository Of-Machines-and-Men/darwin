class_name SpawnToolbar
extends Control

@export var definitions: Array[GoonDefinition] = []
@export var hotbar_slots_container: Container

var selected_definition: GoonDefinition = null
var hotbar_slots: Array[SpawnToolbarPanel] = []

signal on_definition_selected(definition: GoonDefinition)

func _ready() -> void:
	hotbar_slots = []
	for child in hotbar_slots_container.get_children():
		if child is SpawnToolbarPanel:
			hotbar_slots.append(child)
			child.on_pressed.connect(_on_slot_pressed)
	populate_slots()

func populate_slots() -> void:
	for i in mini(definitions.size(), hotbar_slots.size()):
		hotbar_slots[i].set_value(definitions[i])
	if not definitions.is_empty() and selected_definition == null:
		selected_definition = definitions[0]

func update_remaining_spawns(count: int) -> void:
	for slot in hotbar_slots:
		slot.set_remaining_spawns(count)

func _on_slot_pressed(definition: GoonDefinition) -> void:
	selected_definition = definition
	on_definition_selected.emit(definition)
