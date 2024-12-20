extends CharacterBody2D

# Enemy properties
@export var speed = 100.0
@export var health = 100
@export var damage = 10
@export var detection_radius = 200.0

# Movement variables
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = Vector2.RIGHT
var player: Node2D = null

func _ready():
	# Initialize the enemy
	add_to_group("enemies")
	
	# Try to find the player node
	player = get_node_or_null("/root/Game/Player")

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Basic movement and player detection logic
	if player:
		var distance_to_player = global_position.distance_to(player.global_position)
		
		if distance_to_player < detection_radius:
			# Move towards player
			direction = (player.global_position - global_position).normalized()
		else:
			# Patrol back and forth
			if is_on_wall():
				direction.x *= -1
	
	# Apply horizontal movement
	velocity.x = direction.x * speed
	
	# Move and slide
	move_and_slide()

func take_damage(amount):
	health -= amount
	if health <= 0:
		die()

func die():
	# Add death effects here (animation, particles, etc.)
	queue_free()

func _on_hitbox_body_entered(body):
	if body.is_in_group("player"):
		# Deal damage to player
		if body.has_method("take_damage"):
			body.take_damage(damage)

# Optional: Add animation functionality
func _update_animation():
	if abs(velocity.x) > 0:
		$AnimatedSprite2D.play("walk")
		$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		$AnimatedSprite2D.play("idle")
