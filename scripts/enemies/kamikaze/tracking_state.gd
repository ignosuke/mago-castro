extends EnemyStateBlueprint

func _enter() -> void:
	enemy._animate("walking")

func on_physics_process(delta: float) -> void:
	if !enemy.ON_ATTACK_RANGE: enemy._track_tower(delta)
	else: state_machine._change_state("ImmolatingState")
