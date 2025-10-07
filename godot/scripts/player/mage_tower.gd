class_name MageTower extends Area2D

@export_range(0, 100) var health: int = 100
@onready var hurt_box: HurtBox = $HurtBox
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	GameManager.tower_pos = global_position
	#print("Posicion de la torre: %s" % GameManager.tower_pos)
	
	GameManager.tower_hurtbox = hurt_box
	hurt_box.DETECTED_HITBOX.connect(_take_damage)
	MessageBus.ATTACK_TOWER.connect(_take_damage)

func _take_damage(damage: int) -> void:
	animation_player.play("take_damage")
	audio.play()
	
	if health - damage <= 0: 
		health = 0
		MessageBus.TOWER_HEALTH_UPDATE.emit(health)
		GameManager.GAME_OVER.emit(false)
		return
	
	health -= damage
	MessageBus.TOWER_HEALTH_UPDATE.emit(health)
