class_name AbilityComponent
extends ComponentBase

@export var abilities: Array[AbilityBase] = []

func add_ability(ability: AbilityBase) -> void:
	abilities.append(ability)

func remove_ability(ability: AbilityBase) -> void:
	abilities.erase(ability)

func _tick_abilities(delta_time: float) -> void:
	for ability in abilities:
		ability.tick(_parent, delta_time)

func _physics_process(delta: float) -> void:
	_tick_abilities(delta)
	
