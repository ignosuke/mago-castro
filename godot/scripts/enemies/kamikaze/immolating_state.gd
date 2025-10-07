extends EnemyStateBlueprint

var elapsed_time: float = 0.0

func _enter() -> void:
	enemy._animate("immolating")

func on_physics_process(delta: float) -> void:
	elapsed_time += delta
	enemy.animator.speed_scale += elapsed_time / 100
	if elapsed_time >= 2.5 && elapsed_time < 10:
		state_machine._change_state("ExplodingState")
