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
