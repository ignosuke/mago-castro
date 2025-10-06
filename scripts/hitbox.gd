class_name HitBox extends Area2D

var DAMAGE: int = 0
var DISABLED: bool = false

@warning_ignore("unused_signal")
signal ENTERED_HURTBOX

func _ready() -> void:
	monitoring = false
	DAMAGE = owner.DAMAGE
