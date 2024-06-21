# https://youtu.be/nKBhz6oJYsc?si=PZQL3FwiR03I1sgy

extends Node2D
@onready var transition = $Player_Omen/trans
@export_subgroup("Node")
@export var player_choice = CharacterBody2D
@export var ground_choice = StaticBody2D

@export_subgroup("Constante")
@export var PLAYER_START_POS := Vector2i(60, 294)
@export var CAM_START_POS := Vector2i(320, 180)
@export var START_SPEED : float = 10.0
@export var min_range_spawn: int = 300
@export var max_range_spawn: int = 500
@export var MAX_SPEED : float = 5.0
@export var SPEED_MODIFIER : int = 3000
@export var MIN_DIFFICULTY : int = 1
@export var MEDIUM_DIFFICULTY: int = 3
@export var MAX_DIFFICULTY : int = 5

# preload obstacle ( spawner directement dans le code faute de temps)
var elec_bot = preload("res://Scenes/Monsters/bot_01.tscn")
var small_monster = preload("res://Scenes/Monsters/small_monster.tscn")
var pig_assassin = preload("res://Scenes/Monsters/Pig_Assassin.tscn")
var pigs_assassin = preload("res://Scenes/Monsters/Pigs_Assassin.tscn")
var troll = preload("res://Scenes/Monsters/Troll.tscn")
var troll_and_pigs = preload("res://Scenes/Monsters/Troll_and_pigs.tscn")
var flower_enemy = preload("res://Scenes/Monsters/flower_enemy.tscn")
var flowers_enemy = preload("res://Scenes/Monsters/flowers_enemy.tscn")
var flowerssss_enemy = preload("res://Scenes/Monsters/flowerssss_enemy.tscn")
var obstacle_types := [elec_bot, small_monster, troll]
var obstacle_types_min_diff := [flower_enemy, small_monster, flowers_enemy, elec_bot]
var obstacle_types_medium_diff := [troll, flowers_enemy, pigs_assassin, pig_assassin]
var obstacle_types_max_diff := [flowers_enemy, flowerssss_enemy, pigs_assassin, troll_and_pigs]
var obstacles: Array

# preload sprites
var tree_04 = preload("res://Scenes/Sprites/tree_04.tscn")
var tree_05 = preload("res://Scenes/Sprites/tree_05.tscn")
var tree_06 = preload("res://Scenes/Sprites/tree_06.tscn")
var sprite_type := [tree_04, tree_05, tree_06]
var sprites: Array

# game variables
var score: int
var ground_height: int
var speed: float
var cam_speed: float
var cam_player_x: float
var screen_size: Vector2i
var game_running: bool
var invicible_power: bool
var invicible_statut: bool
var last_obs
var last_sprite
var difficulty

# signal
signal speed_var(speed_value)

func _ready():
	# set screen_size variable and ground height
	screen_size = Vector2i(640, 360)
	ground_height = $GroundUndergroundLvl.get_node("Sprite2D").texture.get_height()
	$Hud.get_node("HighScoreLabel").text = "High Score: " + str(Global.globalscore / Global.SCORE_MODIFIER) + " "
	
	new_game()

func new_game():
	# reset variables
	score = 0
	show_score()
	game_running = false
	difficulty = 0
	
	# reset start values
	player_choice.position = PLAYER_START_POS
	player_choice.velocity = Vector2i(0, 0)
	ground_choice.position = Vector2i(0, -358)
	
	# reset all obstacles
	obstacle_types = [flower_enemy, pig_assassin, troll]
	
	for obs in obstacles:
		obs.queue_free()
	obstacles.clear()
	
	# reset hud & game over screen
	$Hud.get_node("SpaceLabel").show()
	$Hud.get_node("18").hide()
	$Hud.get_node("Control/ProgressBar").hide()
	
	# reset invincible power
	invicible_power = false
	invicible_statut = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# speed up and difficulty
	if game_running:
		speed = START_SPEED + score / SPEED_MODIFIER
		if speed > MAX_SPEED:
			speed = MAX_SPEED
		adjust_difficulty()
		
		# obstacle spwaner
		invicible_activation()
		generate_obs()
		generate_sprite()
		
		# Move player
		player_choice.position.x += speed
		$Player_Omen/trans/ColorRect.position.x =+ player_choice.position.x - 140
		
		# Update ground position
		if cam_player_x - ground_choice.position.x > screen_size.x:
			ground_choice.position.x += screen_size.x - 100
		
		# score
		score += speed 
		show_score()
		
		# remove obstacles and sprites
		for obs in obstacles:
			if obs.position.x < (cam_player_x - screen_size.x):
				remove_obs(obs)
		
		for sprite in sprites:
			if sprite.position.x < (cam_player_x - screen_size.x):
				remove_sprite(sprite)
		
		# emit signal
		speed_var.emit(speed)
		
	else:
		# start the game with space
		if Input.is_action_just_pressed("ui_accept"):
			game_running = true
			$Hud.get_node("SpaceLabel").hide()

 #obstacle / sprites spwaner (FAIRE LES COMMENTAIRES !!)
func generate_obs():
	if difficulty == MIN_DIFFICULTY:
		obstacle_types = obstacle_types_min_diff
	elif difficulty == MEDIUM_DIFFICULTY:
		obstacle_types = obstacle_types_medium_diff
	elif difficulty == MAX_DIFFICULTY:
		obstacle_types = obstacle_types_max_diff
		
	if obstacles.is_empty() or (last_obs.position.x - player_choice.position.x ) < score + randi_range(min_range_spawn, max_range_spawn):
		var obs_type = obstacle_types[randi() % obstacle_types.size()]
		var obs
		obs = obs_type.instantiate()
		var spriteheight = obs.get_node("AnimatedSprite2D").sprite_frames.get_frame_texture("idle", 0)
		var obs_height = spriteheight.get_size()
		var obs_x: int = screen_size.x + score + 100
		var obs_y: int = screen_size.y - ground_height - (obs_height.y/2) + 15
		last_obs = obs
		add_obs(obs, obs_x + player_choice.position.x, obs_y)

func generate_sprite():
	if sprites.is_empty() or (last_sprite.position.x - player_choice.position.x ) < score + randi_range(min_range_spawn-100, max_range_spawn):
		var sprt_type = sprite_type[randi() % sprite_type.size()]
		var sprite
		sprite = sprt_type.instantiate()
		var sprite_height = sprite.get_node("Sprite2D").texture.get_height()
		var sprite_x: int = screen_size.x + score + 100
		var sprite_y: int = screen_size.y - ground_height - (sprite_height / 2) + 15
		last_sprite = sprite
		add_sprite(sprite, sprite_x + player_choice.position.x, sprite_y)

# add obstacles & sprites
func add_obs(obs, x, y):
	obs.position = Vector2i(x, y)
	obs.body_entered.connect(hit_obs)
	add_child(obs)
	obstacles.append(obs)

func add_sprite(sprite, x, y):
	sprite.position = Vector2i(x, y)
	add_child(sprite)
	sprites.append(sprite)

# remove obstacles & sprites
func remove_obs(obs):
	obs.queue_free()
	obstacles.erase(obs)

func remove_sprite(sprite):
	sprite.queue_free()
	sprites.erase(sprite)
	
# on hit condition: game over or invicibility
func hit_obs(body):
	if body.name == "Player_Omen" && not invicible_statut:
		game_over()
	
# score & highscore
func show_score():
	$Hud.get_node("ScoreLabel").text = " Score: " + str(score / Global.SCORE_MODIFIER)

func check_high_score():
	if score > Global.globalscore:
		Global.globalscore = score
		$Hud.get_node("HighScoreLabel").text = "High Score: " + str(Global.globalscore / Global.SCORE_MODIFIER) + " "

# power up activation
func invicible_activation():
	if difficulty == MEDIUM_DIFFICULTY:
		invicible_power = true
		$Hud.get_node("18").show()
		$Hud.get_node("Control/ProgressBar").show()
	
	# power up use	
	if invicible_power && Input.is_action_just_pressed("bite"):
		$InvicibleTimer.start()
		$InvicibleHudTimer.start()
		invicible_statut = true
		$Player_Omen.modulate = Color(1,1,1,0.7)
		$Player_Omen/Invu.play()

# game over & difficulty adjustement	
func game_over():
	$Player_Omen/ded.play()
	check_high_score()
	invicible_power = false
	#get_tree().paused = true
	game_running= false
	transition.play("fade")

func adjust_difficulty():
	difficulty = score / SPEED_MODIFIER
	if difficulty > MAX_DIFFICULTY:
		difficulty = MAX_DIFFICULTY

# all signal
func _on_player_omen_camera_player(camera_pos_x):
	cam_player_x = camera_pos_x 

func _on_invicible_timer_timeout():
	invicible_statut = false
	$InvicibleChargeTimer.start()
	$InvicibleHudTimer.stop()
	$Hud.get_node("Control/ProgressBar").value = 0

func _on_invicible_hud_timer_timeout():
	$Hud.get_node("Control/ProgressBar").value -= 1

func _on_invicible_charge_timer_timeout():
	$Player_Omen/RetourInvu.play()
	$Hud.get_node("Control/ProgressBar").value = 10
	
func _on_trans_animation_finished(anim_name):
	get_tree().change_scene_to_file("res://SceneSapo/gameover.tscn")
