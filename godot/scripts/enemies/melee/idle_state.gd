extends EnemyStateBlueprint

func _enter():
	enemy._animate("idle")

func on_physics_process(_delta: float) -> void:
	if !enemy.ON_ATTACK_RANGE:
		state_machine._change_state("TrackingState")
	elif enemy.ATTACK_COOLDOWN_TIMER.time_left <= 0:
		state_machine._change_state("AttackState")
