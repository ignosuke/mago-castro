class_name HurtBox extends Area2D

signal DETECTED_HITBOX(incoming_damage: int)

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	#print("Area entered: %s - from: %s" % [area.name, area.owner.name])
	if area is HitBox && !area.DISABLED:
		#print("Entré %s " %area.DAMAGE)
		area.ENTERED_HURTBOX.emit()
		DETECTED_HITBOX.emit(area.DAMAGE)
