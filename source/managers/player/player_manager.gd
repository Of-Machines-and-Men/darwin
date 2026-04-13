extends Node

var goon_definitions: Array[GoonDefinition] = []
var points: int = 0

signal on_points_changed(new_total: int)
signal on_definition_added(definitions: Array[GoonDefinition])
signal on_definition_changed(definitions: Array[GoonDefinition])

func initialise(default_goons: Array[GoonDefinition], starting_points: int) -> void:
	points = starting_points
	goon_definitions = default_goons
	
func add_points(amount: int) -> void:
	points += amount
	on_points_changed.emit(points)

func subtract_points(amount: int) -> void:
	points -= amount
	on_points_changed.emit(points)
	
func add_goon(goon: GoonDefinition) -> void:
	goon_definitions.append(goon)
	on_definition_added.emit(goon_definitions)
