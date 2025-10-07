extends Node2D

func _animation_finished() -> void:
	queue_free()
