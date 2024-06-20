extends Node
class_name CameraComponent

@export var camera2D: Camera2D

func handle_camera_initial_position(player: CharacterBody2D) -> void:
	if player != null:
		camera2D.global_position =  player.global_position
