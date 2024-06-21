extends CharacterBody2D


# Commencer par associer les différents components via l'Inspector
# Vérifier les settings de chaque components en allant sur leur propre Inspector
@export_subgroup("Nodes")
@export var gravity_component: GravityComponent
@export var input_component: InputComponent
@export var movement_component: MovementComponent
@export var jump_component: JumpComponent
@export	var animation_component: AnimationComponent
@export var animation_tree: AnimationTree
@export var camera_component: CameraComponent
@export var collision_component: CollisionComponent

var speed: float
var camera_pos: float

signal speed_auto(speed_value)
signal camera_player(camera_pos_x)

func _ready():
	animation_tree.active = true		# Activation de l'AnimationTree
	
func _physics_process(delta):
	# les mouvements
	gravity_component.handle_gravity(self, delta)
	movement_component.handle_horizontal_movement(self, input_component.input_horizontal)
	jump_component.handle_jump(self,input_component.get_jump_input(),input_component.get_jump_released())
	
	# les animations
	animation_component.handle_move_animation(input_component.input_horizontal)
	animation_component.handle_jump_animation(jump_component.is_going_up, gravity_component.is_falling)
	animation_component.handle_landing_animation(self)
	
	# la caméra
	camera_component.handle_camera_initial_position(self)
	camera_pos = $Camera2D.global_position.x
	camera_player.emit(camera_pos)
	
	# les collisions
	collision_component.handle_collision(self, input_component.input_horizontal, jump_component.is_going_up, gravity_component.is_falling)
	
	move_and_slide()
	update_animation()
	
func update_animation():
	animation_tree.set("parameters/Move/blend_position", input_component.input_horizontal)

func _on_city_lvl_speed_var(speed_value):
	speed = speed_value
	speed_auto.emit(speed)

func _on_underground_speed_var(speed_value):
	speed = speed_value
	speed_auto.emit(speed)
