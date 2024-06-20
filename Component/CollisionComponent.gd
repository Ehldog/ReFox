extends Node
class_name CollisionComponent

@export_subgroup("Nodes")
@export var idle_CollisionPolygon: CollisionShape2D
@export var run_CollisionPolygon: CollisionShape2D
@export var jump_CollisionPolygon: CollisionShape2D
@export var fall_CollisionPolygon: CollisionShape2D

func handle_collision(body: CharacterBody2D, move_direction: float, is_jumping: bool, is_falling: bool) -> void:
	if body.is_on_floor() && move_direction == 0:
		idle_CollisionPolygon.disabled = false
		run_CollisionPolygon.disabled = true
		jump_CollisionPolygon.disabled = true
		fall_CollisionPolygon.disabled = true
	elif body.is_on_floor() && move_direction != 0:
		idle_CollisionPolygon.disabled = true
		run_CollisionPolygon.disabled = false
		jump_CollisionPolygon.disabled = true
		fall_CollisionPolygon.disabled = true
	elif is_jumping:
		idle_CollisionPolygon.disabled = true
		run_CollisionPolygon.disabled = true
		jump_CollisionPolygon.disabled = false
		fall_CollisionPolygon.disabled = true
	elif is_falling:
		idle_CollisionPolygon.disabled = true
		run_CollisionPolygon.disabled = true
		jump_CollisionPolygon.disabled = true
		fall_CollisionPolygon.disabled = false
