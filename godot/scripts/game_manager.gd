extends Node

## Global position of the Mage Tower
var tower_pos: Vector2
var tower_hurtbox: HurtBox
var started: bool = false
var paused: bool = false

var start_time: float
var elapsed_seconds: float
var display_time: String = "00:00"

var pause_start_time: float = 0.0
var total_paused_time: float = 0.0

var is_game_over: bool = false
var game_over_scene: PackedScene = preload("res://scenes/ui/GameOver.tscn")

var cooldowns = {
	FLAME = 0.0,
	FIREBOLT = 0.0,
	JOLT = 0.0
}

var max_cooldowns = {
	FLAME = 2.0,
	FIREBOLT = 4.0,
	JOLT = 0.2
}

func _ready() -> void:
	MessageBus.GAME_WON.connect(func(): end_game(true))
	MessageBus.GAME_LOST.connect(func(): end_game(false))
	MessageBus.RESTART.connect(start)

func _process(delta: float) -> void:
	if is_game_over:
		return
	
	if started:
		if !paused:
			elapsed_seconds = (
				Time.get_unix_time_from_system() - 
				start_time - 
				total_paused_time
			)
			format_time(elapsed_seconds)
			
			for spell in cooldowns:
				if cooldowns[spell] > 0:
					cooldowns[spell] -= delta
					
					var progress = cooldowns[spell] / max_cooldowns[spell]
					MessageBus.COOLDOWN_UPDATED.emit(
						spell, 
						cooldowns[spell], 
						progress
					)
					
					if cooldowns[spell] <= 0.0:
						cooldowns[spell] = 0.0
						MessageBus.COOLDOWN_ENDED.emit(spell)

func start_cooldown(spell_name: String) -> bool:
	if is_on_cooldown(spell_name):
		return false
	
	cooldowns[spell_name] = max_cooldowns[spell_name]
	MessageBus.COOLDOWN_STARTED.emit(spell_name, max_cooldowns[spell_name])
	return true

func is_on_cooldown(spell_name: String) -> bool:
	return cooldowns.get(spell_name, 0.0) > 0.0

func get_cooldown_time(spell_name: String) -> float:
	return cooldowns.get(spell_name, 0.0)

func get_cooldown_progress(spell_name: String) -> float:
	if spell_name not in cooldowns or spell_name not in max_cooldowns:
		return 0.0
	
	if max_cooldowns[spell_name] == 0:
		return 0.0
	
	return cooldowns[spell_name] / max_cooldowns[spell_name]

func format_time(total_seconds) -> void:
	var minutes = total_seconds / 60
	var seconds = int(total_seconds) % 60
	display_time = "%02d:%02d" % [minutes, seconds]

func _relative_position_to_tower(relative_body_pos: Vector2) -> int:
	var x: int = 1 if relative_body_pos.x <= tower_pos.x else -1
	return x 

func _coin_flip() -> bool:
	return randi() % 2

func start() -> void:
	is_game_over = false
	start_time = Time.get_unix_time_from_system()
	total_paused_time = 0.0
	elapsed_seconds = 0.0
	for cd in cooldowns: 
		cooldowns[cd] = 0.0
	started = true

func toggle_pause() -> void:
	paused = !paused
	
	if paused:
		pause_start_time = Time.get_unix_time_from_system()
	else:
		var pause_duration = Time.get_unix_time_from_system() - pause_start_time
		total_paused_time += pause_duration
	
	get_tree().paused = paused

func end_game(victory_flag: bool) -> void:
	if !is_game_over:
		var game_over = game_over_scene.instantiate()
		game_over.won = victory_flag
		add_child(game_over)
		is_game_over = true
