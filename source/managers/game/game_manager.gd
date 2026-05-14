extends Node

enum GamePhase { MENU, COMBAT, LAB }

var current_round: int = 1
var current_phase: GamePhase = GamePhase.MENU
var round_timer: float = 30.0
var round_durations: Array[float]
var is_paused: bool

signal on_start_game()
signal on_pause_game()
signal on_unpause_game()
signal on_round_start(round_number: int)
signal on_round_end(round_number: int)
signal on_phase_changed(phase: GamePhase)
signal on_timer_tick(remaining: float)
signal on_game_over()

func start_game(game_config: GameConfig) -> void:
	initialise(game_config.get_round_times())
	PlayerManager.initialise(game_config.starting_goons, game_config.starting_points)
	HeroManager.initialise(game_config.base_hero)
	get_tree().change_scene_to_file("res://source/scenes/levels/simple_arena.tscn")
	on_start_game.emit()
	set_phase(GamePhase.COMBAT)

func pause_game() -> void:
	if current_phase in [GamePhase.COMBAT, GamePhase.LAB]:
		is_paused = true
		on_pause_game.emit()

func unpause_game() -> void:
	is_paused = false
	on_unpause_game.emit()

func initialise(round_time_limits: Array[float]) -> void:
	current_round = 1
	current_phase = GamePhase.COMBAT
	round_durations = round_time_limits
	round_timer = round_durations[current_round - 1]
	on_round_start.emit(current_round)

func _process(delta: float) -> void:
	if current_phase == GamePhase.COMBAT:
		round_timer -= delta
		on_timer_tick.emit(round_timer)
		if round_timer <= 0.0:
			end_round()

func start_round() -> void:
	current_round += 1
	set_phase(GamePhase.COMBAT)
	round_timer = round_durations[current_round - 1]
	on_round_start.emit(current_round)
	
func end_round() -> void:
	on_round_end.emit(current_round)
	if current_round > round_durations.size():
		set_phase(GamePhase.MENU)
		on_game_over.emit()
	else:
		set_phase(GamePhase.MENU)
	
func set_phase(new_phase: GamePhase) -> void:
	if new_phase != current_phase:
		current_phase = new_phase
		on_phase_changed.emit(current_phase)
