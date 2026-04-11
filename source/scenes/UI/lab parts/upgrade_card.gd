class_name UpgradeCard
extends Node2D

signal card_pressed

@onready var rarity_label: Label = $RarityLabel
@onready var name_label: Label = $NameLabel
@onready var effect_label: Label = $EffectLabel
@onready var click_button: Button = $ClickButton

func setup(definition: UpgradeDefinition) -> void:
	rarity_label.text = UpgradeRarity.get_display_name(definition.rarity)
	name_label.text = definition.upgrade_name
	effect_label.text = definition.description

func _ready() -> void:
	click_button.pressed.connect(func(): card_pressed.emit())
	
