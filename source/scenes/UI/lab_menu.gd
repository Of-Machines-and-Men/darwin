class_name LabMenu
extends Node2D

signal upgrade_chosen(definition: UpgradeDefinition)

const CARD_SCENE: PackedScene = preload("res://source/scenes/UI/lab parts/UpgradeCard.tscn")
const REROLL_COST: int = 5

var upgrade_database: UpgradeDatabase

@onready var card_slot_1: Marker2D = $CanvasLayer/Control/VBoxContainer/ContentRow/Treadmill/CardSlot_1
@onready var card_slot_2: Marker2D = $CanvasLayer/Control/VBoxContainer/ContentRow/Treadmill/CardSlot_2
@onready var card_slot_3: Marker2D = $CanvasLayer/Control/VBoxContainer/ContentRow/Treadmill/CardSlot_3
@onready var reroll_button: Button = $CanvasLayer/Control/RerollButton
@onready var mutie_label: Label = $CanvasLayer/Control/VBoxContainer/TopBar/MutiePointsLabel
@onready var rerolls_label: Label = $CanvasLayer/Control/VBoxContainer/TopBar/RerollsLabel

var _rerolls_remaining: int = 2

func _ready() -> void:
	reroll_button.pressed.connect(_on_reroll_pressed)
	MutiePointsManager.on_points_changed.connect(_refresh_mp_label)
	_refresh_mp_label(MutiePointsManager.current_points)
	_populate(upgrade_database.roll_upgrades(3))

func _populate(upgrades: Array[UpgradeDefinition]) -> void:
	var slots: Array[Marker2D] = [card_slot_1, card_slot_2, card_slot_3]
	for slot in slots:
		for child in slot.get_children():
			child.queue_free()
	for i in mini(upgrades.size(), slots.size()):
		var card: UpgradeCard = CARD_SCENE.instantiate()
		slots[i].add_child(card)
		card.setup(upgrades[i])
		card.card_pressed.connect(_on_card_pressed.bind(upgrades[i]))

func _on_card_pressed(definition: UpgradeDefinition) -> void:
	upgrade_chosen.emit(definition)

func _on_reroll_pressed() -> void:
	if _rerolls_remaining <= 0:
		return
	if not MutiePointsManager.spend_points(REROLL_COST):
		return
	_rerolls_remaining -= 1
	rerolls_label.text = "Rerolls: %d" % _rerolls_remaining
	reroll_button.disabled = (_rerolls_remaining <= 0)
	_populate(upgrade_database.roll_upgrades(3))

func _refresh_mp_label(new_total: int) -> void:
	mutie_label.text = "MP: %d" % new_total