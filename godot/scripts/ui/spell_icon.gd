class_name SpellIcon extends Control

@export var this_spell: String = ""
@export var icon: Texture2D

@onready var cooldown_overlay: TextureProgressBar = $CooldownOverlay
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	$Icon.texture = icon
	
	MessageBus.COOLDOWN_STARTED.connect(_on_cooldown_started)
	MessageBus.COOLDOWN_UPDATED.connect(_on_cooldown_updated)
	MessageBus.COOLDOWN_ENDED.connect(_on_cooldown_ended)

func _on_cooldown_started(spell_name: String, _duration: float):
	if this_spell != spell_name:
		return
	
	cooldown_overlay.value = 100.0

func _on_cooldown_updated(spell_name: String, _time_left: float, progress: float):
	if this_spell != spell_name:
		return
	
	cooldown_overlay.value = progress * 100

func _on_cooldown_ended(spell_name: String):
	if this_spell != spell_name:
		return
	
	play_ready_animation()

func play_ready_animation():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	
	tween.tween_property(self, "scale", Vector2(0.9, 0.9), 0.1)
	tween.tween_property(self, "scale", Vector2(1.15, 1.15), 0.15)
	tween.tween_property(self, "scale", Vector2.ONE, 0.12)
	
	audio.play()
