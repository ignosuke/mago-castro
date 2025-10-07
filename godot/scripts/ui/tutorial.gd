extends CanvasLayer

@onready var dialog_label: Label = %Dialog
@onready var continue_label: Label = %Continue

const dialog_msgs = [
	"Hello traveler, seems like we've got some company",
	"These guys never let me enjoy myself",
	"I could use some help, whatdya say?",
	"Listen, I lend you my magic",
	"Try casting this spell: FLAME"
]

func _ready() -> void:
	print(dialog_msgs[0])
