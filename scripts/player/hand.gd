class_name Hand extends Node2D

@onready var sprite: Sprite2D = $Sprite2D

var gestures: Array[String] = [
	"res://assets/sprites/player/fist.png",
	"res://assets/sprites/player/open.png",
	"res://assets/sprites/player/punch.png",
	"res://assets/sprites/player/extended back.png",
	"res://assets/sprites/player/extended front.png"
]

var last_picked: String = "res://assets/player/open.png"

func change_gesture():
	sprite.texture = load(select_gesture())

func select_gesture() -> String:
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
