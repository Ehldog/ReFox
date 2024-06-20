# Source : https://youtu.be/yzbxoZFsU2Y?si=xFKSeX7cd5C0P22Q

extends Node
class_name InputComponent

var input_horizontal: float = 0.0		# var correspondant à la valeur du déplacement horizontal
var speed_auto: float

func _process(delta):
	#input_horizontal = Input.get_axis("move_left", "move_right")		# Récupération du déplacement horizontal: une valeur comprise en -1 et 1, de GAUCHE et DROITE
	input_horizontal = speed_auto
# Input "jump"
# ENTREE : l'action de pressé la touche "jump"
# BUT : vérifié si la touche "jump" est pressée
# SORTIE : vrais ou faux
func get_jump_input() -> bool:
	return Input.is_action_just_pressed("jump")

# Input release "jump"
# ENTREE : l'action de relaché la touche "jump"
# BUT : vérifié si la touche "jump" est relachée
# SORTIE : vrais ou faux	
func get_jump_released() -> bool:
	return Input.is_action_just_released("jump")


func _on_player_glitch_speed_auto(speed_value):
	speed_auto = speed_value # Replace with function body.

func _on_player_omen_speed_auto(speed_value):
	speed_auto = speed_value # Replace with function body.
