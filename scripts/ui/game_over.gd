extends Node2D

@export_group("")
@export var game_over: Texture2D
@export var you_won: Texture2D
@export var win_audio_stream: AudioStream
@export var you_lose: Texture2D
@export var lose_audio_stream: AudioStream

@onready var game_over_sprite: Sprite2D = $GameOverSprite
@onready var message_sprite: Sprite2D = $MessageSprite
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

var won: bool = false

func _ready() -> void:
	game_over_sprite.texture = game_over
	
	z_index = 100
	position = get_viewport().get_visible_rect().size / 2
	game_over_sprite.scale = Vector2.ZERO
	message_sprite.scale = Vector2.ZERO
	_enter_transition()

func _enter_transition() -> void:
	create_tween().tween_property(game_over_sprite, "scale", Vector2(1.5, 1.5), 0.8)\
	.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)\
	.finished.connect(_message_transition)

func _message_transition() -> void:
	if won:
		audio.stream = win_audio_stream
		message_sprite.texture = you_won
	else:
		audio.stream = lose_audio_stream
		message_sprite.texture = you_lose
		message_sprite.offset.x += 32
	audio.play()
	create_tween().tween_property(message_sprite, "scale", Vector2(1.2, 1.2), 0.5)\
	.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
