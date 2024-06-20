extends Node2D

@onready var transition = $MovementParralax/transition
@onready var SelectNoise = $Select

var stage = false

func _on_bck_pressed():
	SelectNoise.play()
	transition.play("fade")


func _on_transition_animation_finished(anim_name):
	get_tree().change_scene_to_file("res://titlescreen.tscn")


func _on_button_player_pressed():
	Global.joueur = false
	print(Global.joueur)


func _on_button_player_2_pressed():
	Global.joueur = true
	print(Global.joueur)


func _on_check_button_pressed():
	stage = !stage
	print(stage)
