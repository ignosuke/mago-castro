class_name Hand extends Node2D

@export var gestures: Array[Texture2D]

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var last_picked: Texture2D

func change_gesture():
	sprite.texture = select_gesture()
	animation_player.play("new_gesture")

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
