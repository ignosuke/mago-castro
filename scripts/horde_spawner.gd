extends Node2D

@export var enemies: Array[PackedScene]
@onready var spawnpoints = $Spawnpoints.get_children()

var spawn_curve: Curve
@export var total_duration: float = 120.0
@export var min_spawn_time: float = 0.5
@export var max_spawn_time: float = 5.0

@onready var spawn_timer: Timer = $SpawnTimer
var elapsed_seconds = GameManager.elapsed_seconds
var is_spawning: bool = false

func _ready() -> void:
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_curve = create_difficulty_curve()

	start_spawning()

func start_spawning():
	is_spawning = true
	schedule_next_spawn()

func _process(_delta: float) -> void:
	elapsed_seconds = GameManager.elapsed_seconds
	if elapsed_seconds >= total_duration && is_spawning:
		stop_spawning()

func create_difficulty_curve() -> Curve:
	var curve = Curve.new()
	curve.min_value = 0.0
	curve.max_value = 1.0
	
	curve.add_point(Vector2(0.0, 0.5))
	curve.add_point(Vector2(12.0, 0.3))
	curve.add_point(Vector2(24.0, 0.3))
	curve.add_point(Vector2(30.0, 1.0))
	
	curve.add_point(Vector2(36.0, 0.4))
	curve.add_point(Vector2(48.0, 0.2))
	curve.add_point(Vector2(60.0, 0.2))
	curve.add_point(Vector2(66.0, 0.9))
	
	curve.add_point(Vector2(72.0, 0.3))
	curve.add_point(Vector2(84.0, 0.0))
	curve.add_point(Vector2(96.0, 0.0))
	curve.add_point(Vector2(102.0, 0.7))
	
	curve.add_point(Vector2(108.0, 0.2))
	curve.add_point(Vector2(120.0, 0.0))
	
	return curve

func get_enemy_weights() -> Array[float]:
	# Return [Melee, Ranged, Kamikaze]
	
	if elapsed_seconds < 36.0:
		# Solo melee
		return [1.0, 0.0, 0.0]
	
	elif elapsed_seconds < 60.0:
		# Melee + algo de ranged
		return [0.7, 0.3, 0.0]
	
	elif elapsed_seconds < 84.0:
		# Melee + ranged + poco kamikaze
		return [0.7, 0.25, 0.05]
	
	else:
		# Ratio final: aproximado 8:3:1
		return [0.5, 0.35, 0.15]

func choose_enemy_type() -> int:
	var weights = get_enemy_weights()
	var total_weight = weights[0] + weights[1] + weights[2]
	
	if total_weight == 0:
		return 0
	
	var random_value = randf() * total_weight
	var cumulative = 0.0
	
	for i in range(weights.size()):
		cumulative += weights[i]
		if random_value <= cumulative:
			return i
	
	return 0

func schedule_next_spawn():
	if not is_spawning:
		return
	
	var curve_value = spawn_curve.sample(elapsed_seconds)
	var spawn_delay = lerp(min_spawn_time, max_spawn_time, curve_value)
	spawn_timer.start(spawn_delay)

func _on_spawn_timer_timeout():
	spawn_enemy()
	schedule_next_spawn()

func spawn_enemy() -> void:
	var spawn_position = spawnpoints.pick_random().global_position
	var enemy_type = choose_enemy_type()
	var enemy_to_spawn = enemies[enemy_type].instantiate()
	
	enemy_to_spawn.global_position = Vector2(
		randf_range(spawn_position.x - 35.0, spawn_position.x + 35.0),
		randf_range(spawn_position.y - 35.0, spawn_position.y + 35.0)
	)
	add_child(enemy_to_spawn)
	
	#var enemy_names = ["Melee", "Ranged", "Kamikaze"]
	#print("%s spawneado en t=%.1fs" % [enemy_names[enemy_type], elapsed_seconds])

func stop_spawning():
	is_spawning = false
	spawn_timer.stop()
	MessageBus.HORDE_COMPLETED.emit()
	#print("\n¡Oleada completa!")
