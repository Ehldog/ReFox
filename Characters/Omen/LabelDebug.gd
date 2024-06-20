extends Label

@export var idle_box: CollisionShape2D
@export var run_box: CollisionShape2D
@export var jump_box: CollisionShape2D
@export var fall_box: CollisionShape2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not run_box.disabled: text = "run"
	elif not idle_box.disabled: text = "idle"
	elif not jump_box.disabled: text = "jump"
	elif not fall_box.disabled: text = "fall"
