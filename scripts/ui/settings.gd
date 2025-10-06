extends VBoxContainer

@onready var master_slider: HSlider = %MasterSlider
@onready var music_slider: HSlider = %MusicSlider
@onready var sfx_slider: HSlider = %SFXSlider

enum AudioBuses {
	MASTER = 0,
	MUSIC = 1,
	SFX = 2
}

func _ready() -> void:
	master_slider.value_changed.connect(_on_master_slider_value_changed)
	music_slider.value_changed.connect(_on_music_slider_value_changed)
	sfx_slider.value_changed.connect(_on_sfx_slider_value_changed)
	
	master_slider.value = AudioServer.get_bus_volume_linear(AudioBuses.MASTER)
	music_slider.value = AudioServer.get_bus_volume_linear(AudioBuses.MUSIC)
	sfx_slider.value = AudioServer.get_bus_volume_linear(AudioBuses.SFX)

func _on_master_slider_value_changed(new_value: float) -> void:
	_set_bus_volume(AudioBuses.MASTER, new_value)

func _on_music_slider_value_changed(new_value: float) -> void:
	_set_bus_volume(AudioBuses.MUSIC, new_value)

func _on_sfx_slider_value_changed(new_value: float) -> void:
	_set_bus_volume(AudioBuses.SFX, new_value)

func _set_bus_volume(bus_idx: int, value: float) -> void:
	if bus_idx == -1 || bus_idx > AudioServer.bus_count:
		print("Bus no existente: idx - %s" % bus_idx)
	AudioServer.set_bus_volume_db(bus_idx, linear_to_db(value))
