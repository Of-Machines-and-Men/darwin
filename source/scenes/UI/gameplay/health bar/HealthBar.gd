class_name HealthBar
extends Control

@onready var _fill_rect: ColorRect = $TextureRect/FillRect
@onready var _flash_rect: ColorRect = $TextureRect/FlashRect

var _max_hp: float = 1.0
