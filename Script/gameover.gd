extends Node2D
@onready var transition = $transition
@onready var SelectNoise = $Select

func _ready():
	$transin.play("fadein")
	
func _on_menu_button_pressed():
	SelectNoise.play()
	transition.play("fade")


func _on_transition_animation_finished(anim_name):
	get_tree().change_scene_to_file("res://titlescreen.tscn")
