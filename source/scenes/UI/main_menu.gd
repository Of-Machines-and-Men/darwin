extends Control

@onready var settings_panel: Panel = $SettingsPanel
@onready var credits_panel: Panel = $CreditsPanel
@onready var master_slider: HSlider = $SettingsPanel/SettingsContent/MasterVolumeRow/MasterSlider
@onready var fullscreen_check: CheckButton = $SettingsPanel/SettingsContent/FullscreenRow/FullscreenCheck

func _ready() -> void:
	settings_panel.hide()
	credits_panel.hide()
	master_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	fullscreen_check.button_pressed = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN

# Hover sounds

func _on_play_button_pressed() -> void:
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://source/scenes/levels/SimpleArena.tscn")

func _on_settings_button_pressed() -> void:
	credits_panel.hide()
	settings_panel.visible = !settings_panel.visible

func _on_credits_button_pressed() -> void:
	settings_panel.hide()
	credits_panel.visible = !credits_panel.visible

func _on_close_pressed() -> void:
	settings_panel.hide()
	credits_panel.hide()

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_master_volume_changed(value: float) -> void:
	var db := linear_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), db)

func _on_fullscreen_toggled(pressed: bool) -> void:
	if pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
