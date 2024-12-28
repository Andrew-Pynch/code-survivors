class_name MultiplyOnHitModifier
extends ProjectileModifier

@export var spawn_count = 2
@export var spread_angle = PI/4

func _init():
	modifier_type = "hit"

func modify_hit(target, damage) -> Dictionary:
	# Spawn additional projectiles
	for i in range(spawn_count):
		var new_projectile = projectile.duplicate()
		var angle = (-spread_angle/2) + (spread_angle/(spawn_count-1)) * i
		new_projectile.direction = projectile.direction.rotated(angle)
		new_projectile.source_projectile = projectile
		projectile.get_tree().root.add_child(new_projectile)
		new_projectile.global_position = projectile.global_position
	
	return {
		"damage": damage,
		"pierce": true  # Allow original projectile to continue
	}
