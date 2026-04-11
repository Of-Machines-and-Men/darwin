## Autoload singleton — tracks Mutie Points (MP).
## MP is earned whenever the Hero takes damage (blood spilled = points earned).
## Register the hero's HealthComponent via register_hero() when the arena scene loads.
extends Node

var current_points: int = 0

signal on_points_changed(new_total: int)

# Registration

## Call this from the Hero (or arena scene) once the hero is in the scene tree.
func register_hero(health_component: HealthComponent) -> void:
	if health_component.on_damaged.is_connected(_on_hero_damaged):
		return
	health_component.on_damaged.connect(_on_hero_damaged)

## Disconnect the old hero when the scene changes (optional cleanup).
func unregister_hero(health_component: HealthComponent) -> void:
	if health_component.on_damaged.is_connected(_on_hero_damaged):
		health_component.on_damaged.disconnect(_on_hero_damaged)

# Points

func add_points(amount: int) -> void:
	current_points += amount
	on_points_changed.emit(current_points)

func spend_points(amount: int) -> bool:
	if not can_afford(amount):
		return false
	current_points -= amount
	on_points_changed.emit(current_points)
	return true

func can_afford(amount: int) -> bool:
	return current_points >= amount

## Hard reset — only call this when starting a new run, not between rounds.
func reset_run() -> void:
	current_points = 0
	on_points_changed.emit(current_points)

# Internal

func _on_hero_damaged(amount: float, _remaining: float, _tags: Array[StringName]) -> void:
	add_points(int(amount))