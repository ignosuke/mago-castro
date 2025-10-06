extends CanvasLayer

signal fade_in_finished
signal fade_out_finished

@onready var fade_rect: ColorRect = ColorRect.new()
var current_tween: Tween

func _ready() -> void:
	layer = 100
	
	fade_rect.color = "#101e29"
	fade_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	fade_rect.modulate.a = 0.0
	fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE 
	add_child(fade_rect)
	
	process_mode = Node.PROCESS_MODE_ALWAYS

func fade_in_transition(duration: float = 1.5) -> void:
	
	fade_rect.modulate.a = 0.0
	fade_rect.show()
	fade_rect.visible = true
	
	if current_tween:
		current_tween.kill()
	
	current_tween = create_tween()
	current_tween.tween_property(fade_rect, "modulate:a", 1.0, duration)
	current_tween.finished.connect(func(): 
		fade_in_finished.emit()
	)

func fade_out_transition(duration: float = 1.5) -> void:
	
	fade_rect.modulate.a = 1.0
	fade_rect.show()
	fade_rect.visible = true
	
	if current_tween:
		current_tween.kill()
	
	current_tween = create_tween()
	current_tween.tween_property(fade_rect, "modulate:a", 0.0, duration)
	current_tween.finished.connect(func(): 
		fade_rect.hide()
		fade_out_finished.emit()
	)

func change_scene_with_fade(scene_path: String, fade_duration: float = 1.5) -> void:
	fade_in_transition(fade_duration)
	await fade_in_finished
	get_tree().change_scene_to_file(scene_path)
	await get_tree().process_frame
	fade_out_transition(fade_duration)
