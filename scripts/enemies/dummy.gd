extends Enemy

@onready var hurt_box: HurtBox = $HurtBox

func _ready() -> void:
	_init(10.0, 0, 0.0, 0.0)

	hurt_box.DETECTED_HITBOX.connect(_take_damage)

	raycast = $RayCast2D

func _track_tower(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	raycast.target_position = GameManager.tower_pos - raycast.global_position

func _take_damage(_incoming_damage: int) -> void:
	queue_free()
