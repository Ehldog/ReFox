extends Camera2D

var camera_player: Vector2i

signal CameraPlayer(CameraPosition)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	camera_player = self.global_position
	
	CameraPlayer.emit(camera_player)
