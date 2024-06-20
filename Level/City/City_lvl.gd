extends Node2D

@export_subgroup("Node")
@export var player_choice = CharacterBody2D
@export var ground_choice = StaticBody2D

@export_subgroup("Setting")
@export var PLAYER_START_POS := Vector2i(60, 294)
@export var START_SPEED : float = 10.0
@export var min_range_spawn: int = 300

# preload obstacle ( spawner directement dans le code faute de temps)
var pig_assassin = preload("res://Scenes/Monsters/Pig_Assassin.tscn")
var troll = preload("res://Scenes/Monsters/Troll.tscn")
var obstacle_types := [pig_assassin, troll]
var obstacles: Array

# game variables & const
const CAM_START_POS := Vector2i(320, 180)

const MAX_SPEED : float = 5.0
const SCORE_MODIFIER : int = 10
const SPEED_MODIFIER : int = 3000

var score: int
var ground_height: int
var speed: float
var cam_speed: float
var cam_player_x: float
var screen_size: Vector2i
var game_running: bool
var last_obs

# signal
signal speed_var(speed_value)

func _ready():
	screen_size = Vector2i(640, 360)
	ground_height = $GroundCityLvl.get_node("Sprite2D").texture.get_height()
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
		print(speed)
		if speed > MAX_SPEED:
			speed = MAX_SPEED
		
		# obstacle spwaner
		generate_obs()
		
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

 #obstacle spwaner (FAIRE LES COMMENTAIRES !!)
func generate_obs():
	if obstacles.is_empty() or (last_obs.position.x - player_choice.position.x ) < score + randi_range(min_range_spawn, 500):
		var obs_type = obstacle_types[randi() % obstacle_types.size()]
		var obs
		obs = obs_type.instantiate()
		var spriteheight = obs.get_node("AnimatedSprite2D").sprite_frames.get_frame_texture("idle", 0)
		var obs_height = spriteheight.get_size()
		var obs_x: int = screen_size.x + score + 100
		var obs_y: int = screen_size.y - ground_height - (obs_height.y/2) + 15
		last_obs = obs
		add_obs(obs, obs_x + player_choice.position.x, obs_y)

func add_obs(obs, x, y):
	obs.position = Vector2i(x, y)
	add_child(obs)
	obstacles.append(obs)
	
func show_score():
	$Hud.get_node("ScoreLabel").text = " Score: " + str(score / SCORE_MODIFIER)

func _on_player_omen_camera_player(camera_pos_x):
	cam_player_x = camera_pos_x # Replace with function body.
