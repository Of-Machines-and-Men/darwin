extends Control

@onready var settings_panel: Panel = $SettingsPanel
@onready var credits_panel: Panel = $CreditsPanel

func _ready() -> void:
	settings_panel.hide()
	credits_panel.hide()

# Hover sounds

func _on_play_button_pressed() -> void:
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://scenes/levels/game_world.tscn")

func _on_settings_button_pressed() -> void:
	credits_panel.hide()
	settings_panel.visible = !settings_panel.visible

func _on_credits_button_pressed() -> void:
	settings_panel.hide()
	credits_panel.visible = !credits_panel.visible

func _on_close_pressed() -> void:
	settings_panel.hide()
	credits_panel.hide()
