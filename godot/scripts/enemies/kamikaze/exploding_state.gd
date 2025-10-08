extends EnemyStateBlueprint

func _enter() -> void:
	enemy.animator.speed_scale = 1.0
	enemy._animate("explode")
	enemy.hurt_box.monitoring = false

func _on_explosion_finished() -> void:
	MessageBus.ATTACK_TOWER.emit(enemy.DAMAGE)
	enemy.queue_free()
