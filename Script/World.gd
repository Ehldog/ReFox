extends Node2D

@onready var tilemap = $GroundCity

const map_size = 128

func _ready():
	generate_world()
	

func generate_world():
	var cells = []
	for x in map_size:
		print("help")
		cells.append(Vector2(x,7))
	tilemap.set_cells_terrain_connect(0,cells,0,0)
