class_name Arrow extends Node2D

var target: Vector2 = Vector2.ZERO
var SPEED: float
var DAMAGE: int
var lifetime_timer: Timer = Timer.new()
@onready var hit_box: HitBox = $HitBox

func _ready() -> void:
	set_as_top_level(true)
	look_at(position + target)
	SPEED = 250.0
	
	add_child(lifetime_timer)
	lifetime_timer.timeout.connect(_on_lifetime_end)
	lifetime_timer.one_shot = true
	lifetime_timer.start(3)
	
	hit_box.ENTERED_HURTBOX.connect(_on_lifetime_end)

func _physics_process(delta: float) -> void:
	position += target * SPEED * delta

func _on_lifetime_end():
	queue_free()
