extends Node2D

@export_subgroup("Node")
@export var player_choice = CharacterBody2D
@export var ground_choice = StaticBody2D

# game variables & const
const PLAYER_START_POS := Vector2i(60, 294)
const CAM_START_POS := Vector2i(320, 180)
const START_SPEED : float = 1.0
const MAX_SPEED : int = 5
const SCORE_MODIFIER : int = 10
const SPEED_MODIFIER : int = 3000

var score: int
var speed: float
var cam_speed: float
var cam_player_x: float
var screen_size: Vector2i
var game_running: bool

# signal
signal speed_var(speed_value)

func _ready():
	screen_size = get_viewport().size
	new_game()

func new_game():
	# reset variables
	score = 0
	show_score()
	# reset start values
	player_choice.position = PLAYER_START_POS
	player_choice.velocity = Vector2i(0, 0)
	ground_choice.position = Vector2i(0, -358)
	$Hud.get_node("SpaceLabel").show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_running:
		speed = START_SPEED + score / SPEED_MODIFIER
		if speed > MAX_SPEED:
			speed = MAX_SPEED
		print(speed)
		
		# Move player
		player_choice.position.x += speed
		
		# Update ground position
		if cam_player_x - ground_choice.position.x > screen_size.x:
			ground_choice.position.x += screen_size.x - 100
		
		# score
		score += speed
		show_score()
		
		# emit signal
		speed_var.emit(speed)
	else:
		if Input.is_action_just_pressed("ui_accept"):
			game_running = true
			$Hud.get_node("SpaceLabel").hide()
	
	$Label.text = str(cam_player_x) + "      " + str(ground_choice.position.x) + " " + str(screen_size.x)
	$Label.position.x = player_choice.position.x

func show_score():
	$Hud.get_node("ScoreLabel").text = " Score: " + str(score / SCORE_MODIFIER)

func _on_player_omen_camera_player(camera_pos_x):
	cam_player_x = camera_pos_x # Replace with function body.
