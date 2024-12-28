extends Node2D

@export var rotation_speed = 10.0
@export var fire_rate = 1.0

@onready var timer = $Timer
@onready var bullet_spawn = $BulletSpawn

var can_shoot = true
var bullet_scene = preload("res://Damageables/Pistol/Bullet/Bullet.tscn")
var active_modifiers = []  # Store active modifiers

func _ready():
	# Set up the shooting timer
	timer.wait_time = fire_rate
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _on_timer_timeout():
	shoot()

func add_modifier(modifier_type: String):
	var new_modifier
	match modifier_type:
		"multiply":
			new_modifier = MultiplyOnHitModifier.new()
		"spiral":
			new_modifier = SpiralMovementModifier.new()
		"explode":
			new_modifier = ExplodeOnKillModifier.new()
	
	if new_modifier:
		active_modifiers.append(new_modifier)

func shoot():
	var bullet = bullet_scene.instantiate()
	
	# Add all active modifiers to the bullet
	for modifier in active_modifiers:
		var mod_instance = modifier.duplicate()
		bullet.add_child(mod_instance)
	
	get_tree().root.add_child(bullet)
	bullet.global_position = bullet_spawn.global_position
	bullet.direction = Vector2.RIGHT.rotated(rotation)

func update_rotation(velocity: Vector2):
	if velocity.length() > 0:
		var target_angle = velocity.angle()
		rotation = lerp_angle(rotation, target_angle, rotation_speed * get_process_delta_time())
