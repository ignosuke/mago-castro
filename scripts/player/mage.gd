class_name Mage extends Node2D

var hand_scene = preload("res://scenes/player/Hand.tscn")
var left_hand: Hand
var right_hand: Hand
var gesture_timer: Timer = Timer.new()

@onready var left_hand_pos: Marker2D = $LeftHand
@onready var right_hand_pos: Marker2D = $RightHand
@onready var watch_zone: Area2D = $WatchZone
@onready var focus: AnimatedSprite2D = $Focus

@onready var spell_spawnpoint: Marker2D = $SpellSpawnpoint

var closest_enemy: Enemy
var enemies_by_proximity: Array[Enemy] = []
var horde_completed: bool = false

var SPELLS = ["FLAME", "FIREBOLT", "JOLT"]

var flame_scene = preload("res://scenes/spells/targeted/Flame.tscn")
var firebolt_scene = preload("res://scenes/spells/targeted/Firebolt.tscn")
var jolt_scene = preload("res://scenes/spells/targeted/Jolt.tscn")

var penalty_timer: Timer = Timer.new()

func _ready() -> void:
	left_hand = hand_scene.instantiate()
	right_hand = hand_scene.instantiate() 
	left_hand.position = left_hand_pos.position
	left_hand.scale.x *= -1
	right_hand.position = right_hand_pos.position
	add_child(left_hand)
	add_child(right_hand)
	
	add_child(gesture_timer)
	gesture_timer.one_shot = true
	gesture_timer.wait_time = 0.5
	
	MessageBus.RECITING_SPELL.connect(_change_hands_gestures)
	
	watch_zone.area_entered.connect(_on_area_entered_watchzone)
	watch_zone.area_exited.connect(_on_area_exited_watchzone)
	focus.visible = false
	
	add_child(penalty_timer)
	penalty_timer.one_shot = true
	penalty_timer.wait_time = 2
	MessageBus.ATTEMPT_CAST.connect(_on_attempt_cast)
	penalty_timer.timeout.connect(_on_penalty_timeout)
	
	MessageBus.HORDE_COMPLETED.connect(func(): horde_completed = true)

func _process(_delta: float) -> void:
	if horde_completed && enemies_by_proximity.is_empty():
		GameManager.GAME_OVER.emit(true)

func _physics_process(_delta: float) -> void:
	if !enemies_by_proximity.is_empty(): 
		sort_enemies_by_distance()
		focus.visible = true
		focus_enemy(closest_enemy)
	else:
		focus.visible = false

func _on_area_entered_watchzone(area: Node2D):
	if !area is Enemy: return
	add_enemy(area)

func _on_area_exited_watchzone(area: Node2D):
	if !area is Enemy: return
	erase_enemy(area)

func add_enemy(e: Enemy) -> void:
	if e in enemies_by_proximity:
		return
	enemies_by_proximity.append(e)
	sort_enemies_by_distance()

func erase_enemy(e: Enemy) -> void:
	if e in enemies_by_proximity: enemies_by_proximity.erase(e)
	sort_enemies_by_distance()

func sort_enemies_by_distance() -> void:
	if enemies_by_proximity.is_empty(): return
	enemies_by_proximity.sort_custom(func(a: Enemy, b: Enemy) -> bool: 
		return a.raycast.target_position.length() < b.raycast.target_position.length()
	)
	closest_enemy = enemies_by_proximity[0]

func focus_enemy(e: Enemy) -> void:
	focus.global_position = e.global_position

func _change_hands_gestures() -> void:
	if gesture_timer.is_stopped():
		gesture_timer.start()
		print("Código MANO: entré - Timer value: %s" % gesture_timer.time_left)
		left_hand.change_gesture()
		right_hand.change_gesture()

func _on_attempt_cast(spell_name: String) -> void:
	if spell_name == "": return
	
	if SPELLS.has(spell_name) && has_method(spell_name):
		if GameManager.cooldowns[spell_name] > 0.0:
			MessageBus.CAST_ON_COOLDOWN.emit(spell_name)
			return
		if call(spell_name): GameManager.start_cooldown(spell_name)
	
	else:
		# Aparecer signos de ?? sobre la cabeza del mago para el feedback de la penalizacion 
		MessageBus.TOGGLE_PENALTY.emit(true)
		penalty_timer.start()

func _on_penalty_timeout() -> void:
	MessageBus.TOGGLE_PENALTY.emit(false)

#region SPELLS
# Target spells: solo son casteados si hay un objetivo. Devuelven true/false para entrar o no en cooldown
func FLAME() -> bool:
	if closest_enemy:
		var flame: Flame = flame_scene.instantiate()
		flame.position = spell_spawnpoint.global_position
		flame.target = flame.position.direction_to(closest_enemy.global_position)
		add_child(flame)
		GameManager.cooldowns["FLAME"] = 2.0
		return true
	return false

func FIREBOLT() -> bool:
	if closest_enemy:
		var firebolt: Firebolt = firebolt_scene.instantiate()
		firebolt.z_index = 10
		firebolt.position = spell_spawnpoint.global_position
		firebolt.target = firebolt.position.direction_to(closest_enemy.global_position)
		add_child(firebolt)
		GameManager.cooldowns["FIREBOLT"] = 4.0
		return true
	return false

func JOLT() -> bool:
	if closest_enemy:
		var jolt: Jolt = jolt_scene.instantiate()
		jolt.position = spell_spawnpoint.global_position
		jolt.target = closest_enemy.global_position
		add_child(jolt)
		GameManager.cooldowns["JOLT"] = 0.2
		return true
	return false
#endregion
