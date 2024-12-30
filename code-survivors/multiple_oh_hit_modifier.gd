class_name MultiplyOnHitModifier
extends ProjectileModifier

@export var spawn_count = 2
@export var spread_angle = PI/4

func _init():
	modifier_type = "hit"

func modify_hit(target, damage) -> Dictionary:
	# Schedule the spawning of new projectiles for the next frame
	call_deferred("_spawn_projectiles", target)
	
	return {
		"damage": damage,
		"pierce": true  # Allow original projectile to continue
	}

func _spawn_projectiles(target):
	# Only proceed if the projectile and target still exist
	if !is_instance_valid(projectile) or !is_instance_valid(target):
		return
		
	var spawn_offset = projectile.direction * 100 # Spawn 100 pixels behind the hit point
	
	for i in range(spawn_count):
		var new_projectile = projectile.duplicate()
		var angle = (-spread_angle/2) + (spread_angle/(spawn_count-1)) * i
		new_projectile.direction = projectile.direction.rotated(angle)
		new_projectile.source_projectile = projectile
		
		# Add the new projectile to the scene tree
		projectile.get_tree().root.call_deferred("add_child", new_projectile)
		
		# Set the position in the next frame
		new_projectile.call_deferred("set_global_position", target.global_position + spawn_offset)
	
	# Queue the original projectile for deletion
	projectile.call_deferred("queue_free")
