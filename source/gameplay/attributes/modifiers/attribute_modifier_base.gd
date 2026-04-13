class_name AttributeModifierBase
extends Resource

enum ModifierType { STATIC, ADDITIVE_FLAT, ADDITIVE_PERCENT, MULTIPLICATIVE_FLAT, MULTIPLICATIVE_PERCENT }
enum ModifierApplicability { ALWAYS, ON_RESTORE, ON_CHANGE, ON_DEPLETE, ON_READ }

@export var affected_attributes: Array[StringName] = []
@export var modifier_tags: Array[StringName] = []
@export var applicability: ModifierApplicability = ModifierApplicability.ON_READ
@export var modifier_type: ModifierType = ModifierType.MULTIPLICATIVE_FLAT
@export var magnitude: float = 1.0
@export var duration: float = INF

## Called when an incoming deplete or restore amount is being processed.
## Override in subclasses to intercept and modify incoming values (e.g. damage reduction).
## Base implementation passes the value through unchanged.
func apply_incoming(incoming: float, _tags: Array[StringName]) -> float:
	return incoming
