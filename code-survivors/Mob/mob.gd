extends RigidBody2D

signal mob_died(gold_value)
@export var gold_value = 10

@export var health = 100
@export var max_health = 100
@export var health_bar_width = 32  # Width of the health bar
@export var health_bar_height = 4  # Height of the health bar
@export var move_speed = 100  # Add movement speed variable

@onready var health_bar = $HealthBar
@onready var damage_bar = $DamageBar
var damage_number_scene = preload("res://HUD/DamageNumbers/damage_number.tscn")
var player = null  # Reference to player

func _ready():
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])
	add_to_group("mobs")
	
	health = max_health
	# Set up both bars with exact same size
	damage_bar.size = Vector2(health_bar_width, health_bar_height)
	health_bar.size = Vector2(health_bar_width, health_bar_height)
	update_health_bar()
	
	# Get player reference
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	if player:
		var direction = (player.global_position - global_position).normalized()
		linear_velocity = direction * move_speed

func take_damage(damage):
	health -= damage
	update_health_bar()
	spawn_damage_number(damage)
	if health <= 0:
		emit_signal("mob_died", gold_value)
		queue_free()

func update_health_bar():
	var health_percent = float(health) / max_health
	# Only adjust the width of the green bar
	health_bar.size.x = health_bar_width * health_percent

func spawn_damage_number(damage):
	var damage_number = damage_number_scene.instantiate()
	damage_number.damage_value = damage
	# Position it above the mob
	damage_number.position = Vector2(0, -30)
	add_child(damage_number)
