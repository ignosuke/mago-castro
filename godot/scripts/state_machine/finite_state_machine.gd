class_name FiniteStateMachine extends Node

@onready var suscribed_node = self.owner

@export var default_state: State
var current_state: State = null

func _ready() -> void:
	call_deferred("_start_default_state")
	
func _start_default_state() -> void:
	current_state = default_state
	_start_state()

func _start_state() -> void:
	current_state.suscribed_node = suscribed_node
	current_state.state_machine = self
	current_state._enter()

func _change_state(incoming_state: String) -> void:
	if current_state and current_state.has_method("_exit"): current_state._exit()
	current_state = get_node(incoming_state)
	_start_state()
#region

func _process(_delta: float) -> void:
	if current_state and current_state.has_method("on_process"): current_state.on_process(_delta)

func _physics_process(_delta: float) -> void:
	if current_state and current_state.has_method("on_physics_process"): current_state.on_physics_process(_delta)

func _input(_event: InputEvent) -> void:
	if current_state and current_state.has_method("on_input"): current_state.on_input(_event)

func _unhandled_input(_event: InputEvent) -> void:
	if current_state and current_state.has_method("on_unhandled_input"): current_state.on_unhandled_input(_event)

func _unhandled_key_input(_event: InputEvent) -> void:
	if current_state and current_state.has_method("on_unhandled_key_input"): current_state.on_unhandled_key_input(_event)

#endregion
