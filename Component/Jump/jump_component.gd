# Source : https://youtu.be/yzbxoZFsU2Y?si=xFKSeX7cd5C0P22Q

extends Node
class_name JumpComponent

@export_subgroup("Nodes")
@export var jump_buffer_timer: Timer		# var définissant le temps du buffer de saut. NE PAS OUBLIER D'ASSIGNER LE TIMER dans l'Inspector.
@export var coyote_timer: Timer				# var définissant le temps/les frames où l'on peut encore sauter. NE PAS OUBLIER D'ASSIGNER LE TIMER dans l'Inspector. (0.08 s = 5 frames à 60 fps)

@export_subgroup("Settings")
@export var jump_velocity: float = -350.0		# var définissant la force du saut (-y)

var is_going_up: bool = false			# var définissant si le character se déplace vers le haut
var is_jumping: bool = false			# var définissant si le character est entrain de sauter
var last_frame_on_floor: bool = false	# var définissant la dernière frame en contact avec le sol

# Vérification fin de saut
# ENTREE : un CharacterBody2D correspondant au character
# BUT : définir si le character à toucher le sol
# SORTIE : vrais / faux
func has_just_landed(body: CharacterBody2D) -> bool:
	return body.is_on_floor() and not last_frame_on_floor and is_jumping # si le character touche le sol ET que la dernière frame ne touche pas le sol ET qui est entrain de sauter on renvoie vrais
	
# Authorisation de sauter
# ENTREE : un CharacterBody2D correspondant au character, la condition du saut provenant de input_component (ligne 16)
# BUT : donner l'authorisation au character de sauter
# SORTIE : vrais / faux
func is_allowed_to_jump(body: CharacterBody2D, want_to_jump: bool) -> bool:
	return want_to_jump and (body.is_on_floor() or not coyote_timer.is_stopped()) # le character peut sauter si l'input du saut est pressé ET que le character touche le sol OU que le timer coyote est stoppé
	
# Gestion du saut
# ENTREE : un CharacterBody2D correspondant au character, la condition du saut provenant de input_component (ligne 16)
# BUT : faire sauter le character
# SORTIE : void
func handle_jump(body: CharacterBody2D, want_to_jump: bool, jump_released: bool) -> void:
	if has_just_landed(body):		# on signifie que le character ne saute plus
		is_jumping = false
	
	if is_allowed_to_jump(body, want_to_jump):	# si le character est authorisé à sauter on lance la fonction de saut: jump
		jump(body)
	
	handle_coyote_time(body)							# on active le timer coyote
	handle_jump_buffer(body, want_to_jump)				# on active le buffer de saut
	handle_variable_jump_height(body, jump_released)	# on applique la fonction allogeant le saut tant que l'input saut n'est pas relaché
	
	is_going_up = body.velocity.y < 0 and not body.is_on_floor()		# verification de l'état saut du character: si il y a vers le haut (-y) ET que le character ne touche pas le sol alors il est
	last_frame_on_floor = body.is_on_floor()		# on fixe la dernière frame de la var sur la position du character quand il touche le sol

# Buffer de saut
# ENTREE : un CharacterBody2D correspondant au character, la condition du saut provenant de input_component (ligne 16)
# BUT : permet d'enchainer les sauts plus facilement 
# SORTIE : void
func handle_jump_buffer(body: CharacterBody2D, want_to_jump: bool) -> void:
	if want_to_jump and not body.is_on_floor():		# lancement du timer lorsque le character saute
		jump_buffer_timer.start()
	
	if body.is_on_floor() and not jump_buffer_timer.is_stopped():	# permet de resauter directement si le buffer est encore actif
		jump(body)
	
# Vérification par rapport au bord du sol
# ENTREE : un CharacterBody2D
# BUT : vérifier que le character vient juste de quitter le sol
# SORTIE : vrais / faux
func has_just_stepped_off_ledge(body: CharacterBody2D) -> bool:
	return not body.is_on_floor() and last_frame_on_floor and not is_jumping	# on return vrais si le character ne touche plus le saut ET que la dernière elle touche le sol ET qu'il n'est pas entrain de sauter
	
# Gestion du moment Coyote
# ENTREE : un CharacterBody2D
# BUT : activation ou mise à zero du timer coyote
# SORTIE : void
func handle_coyote_time(body: CharacterBody2D) -> void:
	if has_just_stepped_off_ledge(body):		# si le character vient de quitter le sol d'un bord on encleche le timer coyote
		coyote_timer.start()
	
	if not coyote_timer.is_stopped() and not is_jumping:	# si le timer coyote est arrêté ET que le character ne saute pas on fixe la velocité y sur réinitialisation
		body.velocity.y = 0
		
# Gestion du saut
# ENTREE : un CharacterBody2D correspondant au character
# BUT : fait sauter le character
# SORTIE : void
func jump(body: CharacterBody2D) -> void:
	body.velocity.y = jump_velocity		# on applique la force du saut
	is_jumping = true
	$"../../JumpSound".play()
	jump_buffer_timer.stop()			# on stoppe le timer du buffer une fois le saut complétement réalisé
	coyote_timer.stop()
	
# Gestion de la hauteur du saut
# ENTREE : un CharacterBody2D correspondant au character, la condition du saut relaché de input_component (ligne 23)
# BUT : faire varier la hauteur du saut
# SORTIE : void
func handle_variable_jump_height(body: CharacterBody2D, jump_released: bool) -> void:
	if jump_released and is_going_up:		# si le character saute et que le bouton saut est relaché alors on fixe la vélocité de l'axe y à zero pour le faire retomber (moment de suspensio en l'air)
		body.velocity.y = 0
