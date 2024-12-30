# ProjectilePool.gd
extends Node

const POOL_SIZE = 1000
var bullet_scene = preload("res://Damageables/Pistol/Bullet/Bullet.tscn")  # Update this path to match your project structure
var available_projectiles = []
var active_projectiles = []

func _ready():
	# Pre-instantiate pool
	for i in POOL_SIZE:
		var projectile = bullet_scene.instantiate()
		projectile.process_mode = Node.PROCESS_MODE_DISABLED  # Start disabled
		projectile.visible = false  # Hide initially
		add_child(projectile)
		available_projectiles.append(projectile)
		
func get_projectile() -> BaseProjectile:
	var projectile
	
	if available_projectiles.size() > 0:
		projectile = available_projectiles.pop_back()
	else:
		# If pool is empty, create new instance
		projectile = bullet_scene.instantiate()
		add_child(projectile)
	
	active_projectiles.append(projectile)
	projectile.process_mode = Node.PROCESS_MODE_INHERIT
	projectile.visible = true
	return projectile

func return_to_pool(projectile: BaseProjectile):
	if projectile in active_projectiles:
		active_projectiles.erase(projectile)
		
	# Reset projectile state
	projectile.process_mode = Node.PROCESS_MODE_DISABLED
	projectile.visible = false
	projectile.distance_traveled = 0
	projectile.killed_enemy = false
	projectile.source_projectile = null
	projectile.global_position = Vector2.ZERO
	projectile.direction = Vector2.RIGHT
	
	# Clear modifiers
	for child in projectile.get_children():
		if child is ProjectileModifier:
			child.queue_free()
	
	available_projectiles.append(projectile)
