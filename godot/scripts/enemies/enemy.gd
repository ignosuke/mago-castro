class_name Enemy extends Area2D

var HEALTH: float
var DAMAGE: int
var SPEED: float
var ATTACK_SPEED: float

var ON_ATTACK_RANGE: bool = false
var ATTACK_COOLDOWN_TIMER: Timer = Timer.new()
var is_attacking: bool = false
var direction_to_tower: Vector2
var raycast: RayCast2D = null

#region INHERITED
func _init(init_health: float = 10.0, init_damage: int = 4, init_speed: float = 10.0, init_attack_speed: float = 3.0):
	HEALTH = init_health
	DAMAGE = init_damage
	SPEED = randf_range(init_speed-2.0, init_speed+2.0)
	#SPEED = 0.0
	ATTACK_SPEED = randf_range(init_attack_speed-0.2, init_attack_speed+0.2)

func _track_tower(delta: float) -> void:
	if !ON_ATTACK_RANGE:
		direction_to_tower = GameManager.tower_pos - global_position
		direction_to_tower = direction_to_tower.normalized()
		position += direction_to_tower * SPEED * delta 

func _animate(_new_animation: String) -> void:
	pass

func _take_damage(_incoming_damage: int) -> void:
	pass

# ???
func _apply_effect(_incoming_effect: String) -> void:
	pass
#endregion
