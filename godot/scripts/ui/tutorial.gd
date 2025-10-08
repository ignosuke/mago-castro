extends CanvasLayer

@onready var dialog_label: Label = %Dialog
@onready var continue_label: Label = %Continue
@onready var dummy: Area2D = $Dummy

var tutorial_completed: bool = false

var current_dialog_idx: int = 0

const dialog_msgs = [
	"Hello traveler, seems like we've got some company",
	"These guys never let me enjoy myself",
	"I could use some help, whatdya say?",
	"Listen, I lend you my magic and you recite the spells",
	"But be careful, if you make a mistake you'll be penalized",
	"Type 'FLAME' and press SPACEBAR to cast your first spell"
]

const casting = "Let's see where this goes..."
const cast_success = "ZAMN you learn quickly, let's have some fun then..."
const cast_error = "Oops, wrong spell. Don't worry, try again: 'FLAME'"

var fade_out_timer: Timer = Timer.new()
@onready var tutorial_container: MarginContainer = $TutorialContainer

func _ready() -> void:
	MessageBus.RECITING_SPELL.connect(func():
		dialog_label.text = casting
	)
	dummy.died.connect(func():
		dialog_label.text = cast_success
		tutorial_completed = true
		MessageBus.DISABLE_CASTING_MACHINE.emit()
		fade_out_timer.start()
	)
	MessageBus.TOGGLE_PENALTY.connect(func(_penalty):
		dialog_label.text = cast_error
	)
	
	dialog_label.text = dialog_msgs[current_dialog_idx]
	
	fade_out_timer.one_shot = true
	fade_out_timer.wait_time = 3.0
	fade_out_timer.timeout.connect(_fade_out)
	add_child(fade_out_timer)

func _input(_event: InputEvent) -> void:
	if !tutorial_completed:
		if Input.is_action_just_pressed("interact") && current_dialog_idx < 10:
			if current_dialog_idx < dialog_msgs.size()-1:
				current_dialog_idx += 1
				dialog_label.text = dialog_msgs[current_dialog_idx]
				await get_tree().process_frame
				if current_dialog_idx == dialog_msgs.size()-1: 
					current_dialog_idx = 10
					MessageBus.ENABLE_CASTING_MACHINE.emit()

func _fade_out() -> void:
	create_tween().tween_property(tutorial_container, "modulate:a", 0.0, 1.0).finished.connect(
		func():
			MessageBus.TUTORIAL_COMPLETED.emit()
			MessageBus.ENABLE_CASTING_MACHINE.emit()
			queue_free()
	)
