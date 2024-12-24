# Pistol.gd
extends Node2D

@export var rotation_speed = 10.0
@export var fire_rate = 1.0  # 1 second interval

@onready var timer = $Timer
@onready var bullet_spawn = $BulletSpawn

var can_shoot = true
var bullet_scene = preload("res://Damageables/Pistol/Bullet/Bullet.tscn")

func _ready():
	# Set up the shooting timer
	timer.wait_time = fire_rate
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _on_timer_timeout():
	shoot()

func shoot():
	var bullet = bullet_scene.instantiate()
	# Add bullet to the game world, not as a child of the gun
	get_tree().root.add_child(bullet)
	# Set bullet position to spawn point
	bullet.global_position = bullet_spawn.global_position
	# Set bullet direction based on gun rotation
	bullet.direction = Vector2.RIGHT.rotated(rotation)

func update_rotation(velocity: Vector2):
	if velocity.length() > 0:
		var target_angle = velocity.angle()
		rotation = lerp_angle(rotation, target_angle, rotation_speed * get_process_delta_time())
