# Source : https://youtu.be/yzbxoZFsU2Y?si=xFKSeX7cd5C0P22Q

extends Node
class_name GravityComponent

@export_subgroup("Settings")
@export var gravity: float = 1000.0		# var définissant la force de gravité s'appliquant sur le character

var is_falling: bool = false			# var définissant si le character est entrain de chuter

# Gestion de la gravité : 
# ENTREE : un CharacterBody2D et le delta
# BUT : si le character ne touche pas le sol alors on lui applique une force de gravité vers le bas (+ y)
# SORTIE : void
func handle_gravity(body: CharacterBody2D, delta: float) -> void:
	if not body.is_on_floor():
		body.velocity.y += gravity * delta
	
	# le character chute si sa velocité y est supérieur à 0 ET que le character ne touche pas le sol
	is_falling = body.velocity.y > 0 and not body.is_on_floor()
	
	# la ligne au dessus est l'équivalent de :
	# if body.velocity.y > 0 and not body.is_on_floor():
	# 	is_falling = true
