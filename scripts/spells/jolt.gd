class_name Jolt extends BaseSpell

@export var speed_curve: Curve
var elapsed_time: float = 0
var target: Vector2 = Vector2.ZERO
var consumed: bool = false
var exploding: bool = false
var vanish_time: Timer = Timer.new()

@onready var animator: AnimatedSprite2D = $Animator
@onready var hit_box: HitBox = $HitBox
@onready var target_direction: Vector2 = position.direction_to(target)
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	set_as_top_level(true)
	look_at(position + target_direction)
	SPEED = 500.0
	DAMAGE = 12
	
	hit_box.DAMAGE = DAMAGE
	hit_box.ENTERED_HURTBOX.connect(_callback)
	
	add_child(vanish_time)
	vanish_time.timeout.connect(_on_vanish_timeout)
	vanish_time.one_shot = true
	vanish_time.start(3)

func _physics_process(delta: float) -> void:
	elapsed_time += delta
	if !consumed:
		var current_speed = SPEED * speed_curve.sample(elapsed_time)
		position += target_direction * current_speed * delta
	elif !exploding:
		exploding = true
		_on_impact()
 
func _on_impact() -> void:
	var frame_size = animator.sprite_frames.get_frame_texture("explode", 0).get_size()
	global_position = target - Vector2(0, frame_size.y/2)
	animator.play("explode")
	audio.play()
	await animator.animation_finished
	queue_free()

func _callback() -> void:
	consumed = true
	hit_box.DISABLED = true

func _on_vanish_timeout() -> void:
	queue_free()
