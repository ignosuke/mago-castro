class_name Hand extends Node2D

@export var gestures: Array[Texture2D]

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var hide_timer: Timer = Timer.new()

var last_picked: Texture2D

func _ready() -> void:
	hide()
	add_child(hide_timer)
	hide_timer.one_shot = true
	hide_timer.wait_time = 0.3
	hide_timer.timeout.connect(func(): animation_player.play("hide_hand"))

func change_gesture():
	sprite.texture = select_gesture()
	animation_player.play("new_gesture")
	hide_timer.start()

func select_gesture() -> Texture2D:
	gestures.shuffle()
	var pick = gestures.pop_front()
	gestures.append(pick)
	
	if last_picked != pick:
		last_picked = pick
		return pick
	else:
		pick = gestures.pop_front()
		gestures.append(pick)
		last_picked = pick
		return pick
