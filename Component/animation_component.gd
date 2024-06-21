# Source : https://youtu.be/yzbxoZFsU2Y?si=xFKSeX7cd5C0P22Q
#https://youtu.be/fuGiJdMrCAk?si=-S41jnFDAfKgZXhN

extends Node
class_name AnimationComponent

# AnimationTree:
# Inialisation de l'AnimationTree spécifique au character
# Mise en place de la commande playback
@onready var animation_tree = $"../../AnimationTree"
@onready var playback = animation_tree.get("parameters/playback")

@export_subgroup("Nodes")
@export var sprite: Sprite2D	# var le node Sprite2D qui sert de sprite au character
#@export var animation_tree: AnimationTree # var le node AnimationTree qui gère les animations du character
@export var fall_animation: String = "fall"

# Gestion du sens de mouvement
# ENTREE : la direction de mouvement du character
# BUT : retourner le sprite du character en fonction de son sens de déplacement
# SORTIE : void
func handle_horizontal_flip(move_direction: float) -> void:
	if move_direction == 0:		# si la direction de mouvement est de 0 (immobile), on return
		return
		
	#sprite.flip_h:
	# le flip du sprite du character se fait si sa direction est inférieur à 0 donc vers la gauche ( déplacement de -1 à 1 cf input_component ligne 9)
	# décalage sur l'offset car le sprite n'est pas centré dans sa zone d'animation
	if move_direction > 0:
		sprite.flip_h = false
		sprite.offset.x = 0
	else:
		sprite.flip_h = true
		sprite.offset.x = -20
# Gestion des animations de mouvement
# ENTREE : la direction de mouvement du character provenant de l'input_component (ligne 9)
# BUT : déclencher l'animation du character en fonction de son action de mouvement
# SORTIE : void
func handle_move_animation(move_direction: float) -> void:
	handle_horizontal_flip(move_direction)		# vérification du sens du sprite
	
# Gestion des animations de saut
# ENTREE : l'état du saut de jump_component (ligne 19) et l'état de chute de gravity_component (ligne 20)
# BUT : déclencher l'animation du character en fonction de son action de saut
# SORTIE : void
func handle_jump_animation(is_jumping: bool, is_falling: bool) -> void:
	if is_jumping:			# si il saute, on joue l'animation de saut
		playback.travel("jump")
	elif is_falling:		# si il chute, on joue l'animation de chute
		playback.travel("fall")

# Gestion de l'animation d'atterissage:
# ENTREE : la position du body du Character2D depuis jump_component (ligne 21)
# BUT : faire la transition en l'animation de chute "fall" et celle de base ("Move")
# SORTIE : void
func handle_landing_animation(body: CharacterBody2D) -> void:
	if body.is_on_floor():
		playback.travel("Move")
	
# Retour 
func _on_animation_tree_animation_finished(anim_name):
	return anim_name == fall_animation
