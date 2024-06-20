extends Node2D

@onready var transition = $MovementParralax/transition
@onready var SelectNoise = $Select

func _on_bck_pressed():
	SelectNoise.play()
	transition.play("fade")


func _on_transition_animation_finished(anim_name):
	get_tree().change_scene_to_file("res://titlescreen.tscn")
