# Pistol.gd
extends Node2D

@export var rotation_speed = 10.0

func update_rotation(velocity: Vector2):
	if velocity.length() > 0:
		var target_angle = velocity.angle()
		rotation = lerp_angle(rotation, target_angle, rotation_speed * get_process_delta_time())
