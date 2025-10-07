extends CanvasLayer

@onready var hud_container: MarginContainer = %HUDContainer
@onready var game_time: Label = %GameTimeLabel
@onready var health_label: Label = %HealthLabel
@onready var texture_progress_bar: TextureProgressBar = %HealthBar

func _ready() -> void:
	hud_container.modulate.a = 0.0
	
	MessageBus.TOWER_HEALTH_UPDATE.connect(_on_tower_health_changed)
	texture_progress_bar.max_value = 100
	texture_progress_bar.value = 100
	
	MessageBus.TUTORIAL_COMPLETED.connect(_show_hud)

func _process(_delta: float) -> void:
	game_time.text = GameManager.display_time

func _show_hud():
	MessageBus.ENABLE_CASTING_MACHINE.emit()
	create_tween().tween_property(hud_container, "modulate:a", 1.0, 1.0).finished.connect(func(): 
		GameManager.start()
	)

func _on_tower_health_changed(current_health: int):
	health_label.text = "Vida: %s" % current_health
	update_health(current_health)

func update_health(percent: float):
	var tween = create_tween().set_parallel(true)
	tween.chain().tween_property(texture_progress_bar, "modulate:v", 1.2, 0.05)
	tween.chain().tween_property(texture_progress_bar, "modulate:v", 1.0, 0.05)
	tween.tween_property(texture_progress_bar, "value", percent, 0.3)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_CUBIC)
