extends EnemyStateBlueprint

func _enter() -> void:
	enemy._animate("attack")
	enemy.ATTACK_COOLDOWN_TIMER.start(enemy.ATTACK_SPEED)

func _on_attack_finished() -> void:
	if enemy.ON_ATTACK_RANGE && !enemy.is_attacking: 
		MessageBus.ATTACK_TOWER.emit(enemy.DAMAGE)
	state_machine._change_state("IdleState")
