class_name Ranged extends Enemy

@onready var animator: AnimatedSprite2D = $Animator
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var bow_sprite: Sprite2D = $Bow
@onready var hurt_box: HurtBox = $HurtBox
@onready var arrow_spawnpoint: Marker2D = $Bow/ArrowSpawnpoint
var arrow_scene = preload("res://scenes/enemies/Arrow.tscn")

func _ready() -> void:
	_init(10.0, 2, 30.0, 3.0)
	ATTACK_COOLDOWN_TIMER.one_shot = true
	add_child(ATTACK_COOLDOWN_TIMER)
	
	animator.scale.x = GameManager._relative_position_to_tower(position)
	$Shade.scale.x = animator.scale.x
	bow_sprite.hide()
	bow_sprite.look_at(GameManager.tower_pos)
	
	hurt_box.DETECTED_HITBOX.connect(_take_damage)
	
	raycast = $RayCast2D

func _physics_process(_delta: float) -> void:
	raycast.target_position = GameManager.tower_pos - raycast.global_position

func shoot() -> void: 
	bow_sprite.show()
	var arrow: Arrow = arrow_scene.instantiate()
	arrow.global_position = arrow_spawnpoint.global_position
	arrow.target = global_position.direction_to(GameManager.tower_pos)
	arrow.DAMAGE = DAMAGE
	add_child(arrow)

func _animate(new_animation: String) -> void:
	animator.play(new_animation)

func _take_damage(incoming_damage: int) -> void:
	HEALTH -= incoming_damage
	if HEALTH > 0: animation_player.play("take_damage")
	queue_free()

func _entered_attack_range(_area: Area2D) -> void:
	ON_ATTACK_RANGE = true

func _exited_attack_range(_area: Area2D) -> void:
	ON_ATTACK_RANGE = false
