class_name ExplodeOnKillModifier
extends ProjectileModifier

@export var explosion_radius = 100.0
@export var explosion_damage = 50

func _init():
	modifier_type = "death"

func on_kill(target):
	# Schedule the explosion creation for the next frame
	call_deferred("_create_explosion", target)

func _create_explosion(target):
	# Check if target is still valid
	if !is_instance_valid(target):
		return
		
	var explosion_scene = preload("res://Damageables/Explosion/Explosion.tscn")
	var explosion = explosion_scene.instantiate()
	
	# Set initial properties
	explosion.global_position = target.global_position
	explosion.damage = explosion_damage
	
	# Add explosion to scene tree
	projectile.get_tree().root.call_deferred("add_child", explosion)
	
	# Set the collision shape radius after adding to scene tree
	explosion.call_deferred("_set_explosion_radius", explosion_radius)
