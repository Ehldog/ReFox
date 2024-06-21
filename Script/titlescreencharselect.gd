extends Node2D

@onready var transition = $MovementParralax/transition
@onready var SelectNoise = $Select
@onready var transitionlvl = $MovementParralax/transitionlvl

func _physics_process(delta):
	if Global.joueur == false:
		$MovementParralax/ButtonPlayer.modulate = Color(4,4,4)
		$MovementParralax/ButtonPlayer2.modulate = Color(0.7,0.7,0.7)
	else:
		$MovementParralax/ButtonPlayer.modulate = Color(0.7,0.7,0.7)
		$MovementParralax/ButtonPlayer2.modulate = Color(4,4,4)
func _ready() -> void:
	$MovementParralax/transin.play("fadein")
	$MovementParralax/transition/ColorRect.visible = false 
	
func _on_bck_pressed():
	SelectNoise.play()
	transition.play("fade")

func _on_start_pressed():
	SelectNoise.play()
	transitionlvl.play("fade")

func _on_transition_animation_finished(anim_name):
	get_tree().change_scene_to_file("res://titlescreen.tscn")


func _on_button_player_pressed():
	SelectNoise.play()
	Global.joueur = false
	print(Global.joueur)


func _on_button_player_2_pressed():
	SelectNoise.play()
	Global.joueur = true
	print(Global.joueur)


func _on_transitionlvl_animation_finished(anim_name):
	if Global.joueur == false:
		get_tree().change_scene_to_file("res://Level/City/City_lvl.tscn")
	else:
		get_tree().change_scene_to_file("res://Level/Underground/Underground.tscn")



