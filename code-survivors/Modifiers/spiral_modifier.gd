class_name SpiralMovementModifier
extends ProjectileModifier

@export var rotation_speed = 5.0
@export var spiral_radius = 50.0
var time_alive = 0

func _init():
	modifier_type = "movement"

func modify_movement(current_direction: Vector2, current_speed: float, delta: float) -> Dictionary:
	time_alive += delta
	
	# Calculate spiral offset
	var spiral_offset = Vector2(
		cos(time_alive * rotation_speed),
		sin(time_alive * rotation_speed)
	) * spiral_radius
	
	# Add spiral motion to current direction
	var modified_direction = current_direction + spiral_offset.normalized() * 0.5
	
	return {
		"direction": modified_direction.normalized(),
		"speed": current_speed
	}
