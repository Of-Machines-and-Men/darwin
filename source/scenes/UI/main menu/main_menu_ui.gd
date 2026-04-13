class_name MainMenuUI
extends CenterContainer

@export var game_config: GameConfig
@export var show_resume_button: bool = false

@onready var resume_button: Button = $VBoxContainer/ResumeButton
@onready var new_game_button: Button = $VBoxContainer/NewGameButton
@onready var settings_button: Button = $"VBoxContainer/Settings Button"
@onready var exit_button: Button = $VBoxContainer/ExitButton
@onready var credits_button: Button = $VBoxContainer/CreditsButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	resume_button.visible = show_resume_button
	
	resume_button.pressed.connect(_on_resume_game)
	new_game_button.pressed.connect(_on_new_game)
	settings_button.pressed.connect(_on_settings)
	credits_button.pressed.connect(_on_credits)
	exit_button.pressed.connect(_on_exit_game)

func _on_resume_game() -> void:
	GameManager.unpause_game()
	
func _on_new_game() -> void:
	GameManager.start_game(game_config)
	
func _on_settings() -> void:
	pass
	
func _on_credits() -> void:
	pass

func _on_exit_game() -> void:
	pass
