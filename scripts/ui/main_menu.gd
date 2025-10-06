extends Control

@onready var start_button: Button = %StartButton
@onready var options_button: Button = %OptionsButton
@onready var exit_button: Button = %ExitButton
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer
@onready var settings: VBoxContainer = %Settings

func _ready() -> void:
	focus_button()
	
	settings.hide()
	
	start_button.pressed.connect(_on_start_button_pressed)
	options_button.pressed.connect(_on_options_button_pressed)
	exit_button.pressed.connect(_on_exit_button_pressed)

func _on_start_button_pressed() -> void:
	start_button.disabled = true
	audio.play()
	FadeManager.change_scene_with_fade("res://scenes/Game.tscn")

func _on_options_button_pressed() -> void:
	start_button.visible = !start_button.visible
	exit_button.visible = !exit_button.visible
	settings.visible = !settings.visible

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func focus_button() -> void:
	start_button.grab_focus()
