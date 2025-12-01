extends Control

onready var slider = $HSlider
onready var mute_button = $CheckButton
onready var fullscreen_button = $CheckFullscreen
onready var zen_button = $CheckZen
onready var music = $Music
onready var menu_button = $MenuButton

var saved_volume = 100
var difficulty = 1

func _ready():
	var config = ConfigFile.new()
	var err = config.load("user://Settings.cfg")

	if err == OK:
		saved_volume = config.get_value("audio", "music_volume", 100)
		var muted = config.get_value("audio", "muted", false)
		slider.value = saved_volume
		mute_button.pressed = muted
		if muted:
			music.volume_db = linear2db(0)
		else:
			music.volume_db = linear2db(saved_volume / 100.0)

		var fullscreen_enabled = config.get_value("display", "fullscreen", false)
		fullscreen_button.pressed = fullscreen_enabled
		OS.window_fullscreen = fullscreen_enabled

		var zen_enabled = config.get_value("gameplay", "zen_mode", false)
		zen_button.pressed = zen_enabled

		difficulty = config.get_value("gameplay", "difficulty", 1)
	else:
		slider.value = 100
		mute_button.pressed = false
		fullscreen_button.pressed = false
		zen_button.pressed = false
		music.volume_db = linear2db(1.0)
		OS.window_fullscreen = false
		difficulty = 1

	var popup = menu_button.get_popup()
	popup.clear()
	popup.add_item("Fácil", 0)
	popup.add_item("Normal", 1)
	popup.add_item("Difícil", 2)
	popup.connect("id_pressed", self, "_on_difficulty_selected")

	_update_menu_text()

func _on_HSlider_value_changed(value):
	if not mute_button.pressed:
		music.volume_db = linear2db(value / 100.0)
	saved_volume = value
	_save_settings()

func _on_CheckButton_toggled(pressed):
	if pressed:
		music.volume_db = linear2db(0)
	else:
		music.volume_db = linear2db(slider.value / 100.0)
	_save_settings()

func _on_CheckFullscreen_toggled(pressed):
	OS.window_fullscreen = pressed
	_save_settings()

func _on_CheckZen_toggled(pressed):
	_save_settings()

func _on_difficulty_selected(id):
	difficulty = id
	_update_menu_text()
	_save_settings()

func _update_menu_text():
	match difficulty:
		0:
			menu_button.text = "Dificultad: Fácil"
		1:
			menu_button.text = "Dificultad: Normal"
		2:
			menu_button.text = "Dificultad: Difícil"

func _save_settings():
	var config = ConfigFile.new()
	config.set_value("audio", "music_volume", slider.value)
	config.set_value("audio", "muted", mute_button.pressed)
	config.set_value("display", "fullscreen", fullscreen_button.pressed)
	config.set_value("gameplay", "zen_mode", zen_button.pressed)
	config.set_value("gameplay", "difficulty", difficulty)
	config.save("user://settings.cfg")

func _on_Tornar_pressed():
	get_tree().change_scene("res://Menu.tscn")
