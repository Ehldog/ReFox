extends Node2D
@onready var transition = $MovementParralax/transition
@onready var Canvassetting = $MovementParralax/CanvasSetting
@onready var SelectNoise = $Select
var fullscreen = false
var settingvis = true

func _ready() -> void:
	$MovementParralax/transin.play("fadein")
	$MovementParralax/transition/ColorRect.visible = false 
	
func _on_button_pressed():  #On lance l'animation de fade avant d'aller dans le deuxième menu
	SelectNoise.play()
	transition.play("fade")
	

func _on_exit_pressed(): #On quitte le jeu
	SelectNoise.play()
	get_tree().quit()
	

func _on_settings_pressed(): #Rend les settings visible/invisible
	SelectNoise.play()
	Canvassetting.visible = settingvis
	settingvis = !settingvis
	

func _on_transition_animation_finished(anim_name): #On va dans le deuxième menu
	get_tree().change_scene_to_file("res://titlescreencharselect.tscn")


func _on_fullscreen_button_pressed(): #On passe de plein écran a mode fenétré
	SelectNoise.play()
	if fullscreen == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		fullscreen = false
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		fullscreen = true
