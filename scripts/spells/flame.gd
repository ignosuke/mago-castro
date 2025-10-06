class_name Flame extends BaseSpell

var target: Vector2 = Vector2.ZERO
var consumed: bool = false
var exploding: bool = false
var vanish_time: Timer = Timer.new()

@onready var animator: AnimatedSprite2D = $Animator
@onready var hit_box: HitBox = $HitBox
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	set_as_top_level(true)
	look_at(position + target)
	SPEED = 320.0
	DAMAGE = 25
	
	hit_box.DAMAGE = DAMAGE
	hit_box.ENTERED_HURTBOX.connect(_callback)
	
	add_child(vanish_time)
	vanish_time.timeout.connect(_on_vanish_timeout)
	vanish_time.one_shot = true
	vanish_time.start(3)

func _physics_process(delta: float) -> void:
	if !consumed:
		position += target * SPEED * delta
	elif !exploding:
		exploding = true
		_on_impact()

func _on_impact() -> void:
	animator.play("explode")
	audio.play()
	await animator.animation_finished
	queue_free()

func _callback() -> void:
	consumed = true

func _on_vanish_timeout() -> void:
	queue_free()
