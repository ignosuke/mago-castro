extends EnemyStateBlueprint

func _enter() -> void:
	enemy.shoot()
	enemy.ATTACK_COOLDOWN_TIMER.start(enemy.ATTACK_SPEED)
	enemy._animate("shoot")

func _on_shoot_finished() -> void:
	state_machine._change_state("IdleState")
