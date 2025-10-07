class_name Kamikaze extends Enemy

@onready var animator: AnimatedSprite2D = $Animator
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hurt_box: HurtBox = $HurtBox

func _ready() -> void:
	_init(10.0, 8, 30.0, 3.0)
	ATTACK_COOLDOWN_TIMER.one_shot = true
	add_child(ATTACK_COOLDOWN_TIMER)
	
	animator.scale.x = GameManager._relative_position_to_tower(position)
	$Shade.scale.x = animator.scale.x

	hurt_box.DETECTED_HITBOX.connect(_take_damage)
	
	raycast = $RayCast2D

func _physics_process(_delta: float) -> void:
	raycast.target_position = GameManager.tower_pos - raycast.global_position

func _animate(new_animation: String) -> void:
	animator.play(new_animation)

func _take_damage(incoming_damage: int) -> void:
	HEALTH -= incoming_damage
	if HEALTH > 0: animation_player.play("take_damage")
	else: queue_free()

func _entered_attack_range(_area: Area2D) -> void:
	ON_ATTACK_RANGE = true

func _exited_attack_range(_area: Area2D) -> void:
	ON_ATTACK_RANGE = false
