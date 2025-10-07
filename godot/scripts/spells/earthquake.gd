class_name Earthquake extends BaseSpell

var tick_damage_timer: Timer = Timer.new()
var vanish_time: Timer = Timer.new()
@onready var hit_box: HitBox = $HitBox

func _ready() -> void:
	DAMAGE = 4
	
	hit_box.DISABLED = true
	
	add_child(vanish_time)
	vanish_time.timeout.connect(_on_vanish_timeout)
	vanish_time.one_shot = true
	vanish_time.wait_time = 3
	vanish_time.start()
	
	add_child(tick_damage_timer)
	tick_damage_timer.timeout.connect(_on_tick_damage_timer_timeout)
	tick_damage_timer.wait_time = 0.4
	tick_damage_timer.start()
	
	MessageBus.SCREEN_SHAKE.emit(vanish_time.wait_time, 30.0)

func _on_vanish_timeout() -> void:
	queue_free()

func _on_tick_damage_timer_timeout() -> void:
	print("Daño")
	hit_box.DISABLED = false
	await get_tree().process_frame
	hit_box.DISABLED = true
