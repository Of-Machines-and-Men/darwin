class_name PoolAttributeBase
extends AttributeBase

@export var min_value: float = 0.0
@export var starting_value: float = 1.0

var _current_value

func tick(delta_time: float):
	pass;

func deplete(amount: float, depletion_tags: Array[StringName] = []):
	var incoming = amount
	
	for modifier in modifiers:
		incoming = modifier.apply_incoming(incoming, depletion_tags)
	
	_current_value = maxf(get_current_value() - incoming, min_value)
	on_deplete.emit(incoming, _current_value)
	
	if (_current_value <= min_value):
		on_empty.emit()

func restore(amount: float, restoration_tags: Array[StringName] = []):
	var incoming = amount
	
	for modifier in modifiers:
		incoming = modifier.apply_incoming(incoming, restoration_tags)
	
	_current_value = minf(get_current_value() + incoming, get_effective_value())
	on_restore.emit(incoming, _current_value)
	
	if (_current_value >= get_effective_value()):
		on_fill.emit()

func get_current_value():
	return _current_value if _current_value != null else starting_value

signal on_deplete(amount: float, resulting_value: float)
signal on_restore(amount: float, resulting_value: float)
signal on_fill()
signal on_empty()
