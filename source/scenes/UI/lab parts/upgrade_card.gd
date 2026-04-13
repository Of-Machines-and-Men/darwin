class_name UpgradeCard
extends Node2D

signal card_pressed

@onready var name_label: Label = $CardBorder/MarginContainer/VBoxContainer/NameLabel
@onready var rarity_label: Label = $CardBorder/MarginContainer/VBoxContainer/RarityLabel
@onready var card_image: TextureRect = $CardBorder/MarginContainer/VBoxContainer/CardImage
@onready var effect_label: Label = $CardBorder/MarginContainer/VBoxContainer/EffectLabel
@onready var click_button: Button = $ClickButton

func setup(definition: UpgradeDefinition) -> void:
	name_label.text = definition.upgrade_name
	rarity_label.text = UpgradeRarity.get_display_name(definition.rarity)
	effect_label.text = definition.description

func _ready() -> void:
	click_button.pressed.connect(func(): card_pressed.emit())
