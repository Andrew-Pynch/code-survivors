# Bullet.gd
extends Area2D

var speed = 700
var direction = Vector2.RIGHT
@export var damage = 50

func _ready():
	# Connect to body_entered since enemy is a RigidBody2D
	body_entered.connect(_on_body_entered)

func _process(delta):
	global_position += direction * speed * delta

func _on_body_entered(body):
	# Check if it's an enemy (RigidBody2D)
	if body.is_in_group("mobs"):  # You'll need to add enemies to this group
		if body.has_method("take_damage"):
			body.take_damage(damage)
	queue_free()  # Destroy bullet after hitting

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
