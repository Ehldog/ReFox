# Source : https://youtu.be/yzbxoZFsU2Y?si=xFKSeX7cd5C0P22Q

extends Node
class_name MovementComponent

@export_subgroup("Settings")
# var définissant la vitesse de mouvement et ses différentes contraintes
@export var speed: float = 100
@export var ground_accel_speed: float = 6.0
@export var ground_decel_speed: float = 8.0
@export var air_accel_speed: float = 10.0
@export var air_decel_speed: float = 3.0

# Gestion du mouvement horizontal
# ENTREE : un CharacterBody2D et une direction
# BUT : le déplacement à l'horizontal du character provenant de l'input_component (ligne 9)
# SORTIE : void
func handle_horizontal_movement(body: CharacterBody2D, direction: float) -> void:
	# création d'une var de contrainte sur la vitesse en fonction de la position au sol ou en l'air
	# si la direction provenant de input_component (ligne 9) est différente de 0 alors on applique la contrainte liée à l'accélération sinon on applique celle de la décéleration
	var velocity_change_speed: float = 0.0
	if body.is_on_floor():
		velocity_change_speed = ground_accel_speed if direction != 0 else ground_decel_speed
	else:
		velocity_change_speed = air_accel_speed if direction != 0 else air_decel_speed
		
	body.velocity.x = move_toward(body.velocity.x, direction * speed, velocity_change_speed)		# utilisation de move_toward pour s'assurer que la vitesse ne dépasse jamais speed
