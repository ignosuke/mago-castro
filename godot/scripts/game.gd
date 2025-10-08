class_name Game extends Node2D

@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

func _ready():
	MessageBus.RESTART.connect(func(): audio.play())
