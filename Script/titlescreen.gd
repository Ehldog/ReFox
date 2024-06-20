extends Node2D
@onready var transition = $MovementParralax/transition
@onready var Canvassetting = $MovementParralax/CanvasSetting
@onready var SelectNoise = $Select
var fullscreen = true
var settingvis = true

func _on_button_pressed():
	SelectNoise.play()
	transition.play("fade")
	

func _on_exit_pressed():
	SelectNoise.play()
	get_tree().quit()
	

func _on_settings_pressed():
	SelectNoise.play()
	Canvassetting.visible = settingvis
	settingvis = !settingvis
	

func _on_transition_animation_finished(anim_name):
	get_tree().change_scene_to_file("res://titlescreencharselect.tscn")


func _on_fullscreen_button_pressed():
	SelectNoise.play()
	if fullscreen == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		fullscreen = false
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		fullscreen = true
