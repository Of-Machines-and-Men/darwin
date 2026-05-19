extends Node2D

const LAB_MENU_SCENE: PackedScene = preload("res://source/scenes/UI/LabMenu.tscn")
const ROUND_DURATION: float = 40.0

func _ready() -> void:
	var spawn_toolbar = get_node("UILayer/GameplayUi/ToolbarAnchor/SpawnToolbar") as SpawnToolbar
	if spawn_toolbar:
		spawn_toolbar.on_definition_selected.connect(self._on_spawn_definition_selected)

	if HeroManager.hero_definition:
		SpawnManager.spawn_hero(HeroManager.hero_definition)

func _on_spawn_definition_selected(definition: GoonDefinition) -> void:
	SpawnManager.spawn_goon(definition)
	print("Selected definition: %s" % definition.display_name)

func _process(delta: float) -> void:
	pass
