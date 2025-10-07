class_name CastingMachine extends Control

signal spell_changed(current_text: String)

var listening: bool = false
var spell_buffer: String = ""
@onready var spell_label: Label = $Label

var on_penalty: bool = false

func _ready() -> void:
	MessageBus.ENABLE_CASTING_MACHINE.connect(func():
		listening = true
		spell_buffer = ""
	)
	
	MessageBus.DISABLE_CASTING_MACHINE.connect(func():
		listening = false
	)
	
	spell_label.text = spell_buffer
	spell_changed.connect(_on_spell_changed)
	MessageBus.TOGGLE_PENALTY.connect(_toggle_penalty)

func _input(event: InputEvent) -> void:
	if listening:
		if GameManager.paused || GameManager.is_game_over || event.ctrl_pressed || event.alt_pressed || event.meta_pressed || event.shift_pressed: return
		
		if event is InputEventKey && event.pressed && !event.echo:
			match event.keycode:
				KEY_SPACE:
					if !on_penalty: attempt_cast(spell_buffer)
					else: penalty_cast_not_possible()
				KEY_ENTER:
					if !on_penalty: attempt_cast(spell_buffer)
					else: penalty_cast_not_possible()
				KEY_BACKSPACE:
					clear_buffer()
				_:
					if spell_buffer.length() < 12 && (event.keycode >= KEY_A && event.keycode <= KEY_Z):
						append_letter(event.as_text_keycode())
			MessageBus.RECITING_SPELL.emit()

func append_letter(ch: String) -> void:
	spell_buffer += ch
	emit_signal("spell_changed", spell_buffer)

func clear_buffer() -> void:
	if spell_buffer.is_empty(): return
	spell_buffer = ""
	emit_signal("spell_changed", spell_buffer)

func attempt_cast(spell_name: String) -> void:
	MessageBus.ATTEMPT_CAST.emit(spell_name)
	clear_buffer()

func _toggle_penalty(penalized: bool):
	if GameManager.started: on_penalty = penalized

func penalty_cast_not_possible() -> void:
	MessageBus.CAST_WHILE_PENALIZED.emit()

func _on_spell_changed(current_text: String) -> void:
	spell_label.text = current_text
