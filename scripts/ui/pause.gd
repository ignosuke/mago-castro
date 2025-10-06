extends Control

func _ready() -> void:
	hide()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		GameManager.toggle_pause()
		visible = !visible
