class_name Firebolt extends BaseSpell

@export var speed_curve: Curve
var elapsed_time: float = 0
var target: Vector2 = Vector2.ZERO
var vanish_time: Timer = Timer.new()

@onready var animator: AnimatedSprite2D = $Animator
@onready var hit_box: HitBox = $HitBox
var impact_scene = preload("res://scenes/spells/targeted/FireboltImpact.tscn")

func _ready() -> void:
	set_as_top_level(true)
	look_at(position + target)
	SPEED = 450.0
	DAMAGE = 25
	
	hit_box.DAMAGE = DAMAGE
	
	add_child(vanish_time)
	vanish_time.timeout.connect(_on_vanish_timeout)
	vanish_time.one_shot = true
	vanish_time.start(3)

func _physics_process(delta: float) -> void:
	elapsed_time += delta
	var current_speed = SPEED * speed_curve.sample(elapsed_time)
	position += target * current_speed * delta

func _on_impact() -> void:
	var impact = impact_scene.instantiate()
	impact.set_as_top_level(true)
	impact.global_position = global_position
	impact.z_index = 1
	add_child(impact)

func _on_vanish_timeout() -> void:
	queue_free()
