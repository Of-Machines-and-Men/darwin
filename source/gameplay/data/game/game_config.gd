class_name GameConfig
extends Resource

@export var number_of_rounds: int = 20
@export var round_base_time: float = 30.0
@export var round_time_increment: float = 2.0

@export var starting_points: int = 10
@export var starting_goons: Array[GoonDefinition] = []
@export var base_hero: GoonDefinition

func get_round_times() -> Array[float]:
	var round_times: Array[float] = []
	for i in number_of_rounds:
		round_times.append(round_base_time + i * round_time_increment)
	return round_times
