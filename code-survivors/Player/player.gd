extends Area2D
signal hit
signal gold_updated(amount)

var screen_size
var current_weapon = null
var gold = 0
var is_dead = false

@export var speed = 400

@onready var weapon_pivot = $WeaponPivot  # We'll add this node to hold weapons
@onready var camera = $Camera2D

func _ready():
	camera = $Camera2D
	screen_size = get_viewport_rect().size
	add_to_group("player")
	hide()
	connect_to_mobs()

func connect_to_mobs():
	var mobs = get_tree().get_nodes_in_group("mobs")
	for mob in mobs:
		if not mob.mob_died.is_connected(collect_gold):
			mob.mob_died.connect(collect_gold)

func collect_gold(amount):
	gold += amount
	gold_updated.emit(gold) # Emit the signal with the new total
	print("Collected gold: ", amount, " Total gold:", gold)
	
func process_movement(delta):
	if not is_dead:
		var velocity = Vector2.ZERO # The player's movement vector.
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1

		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
			$AnimatedSprite2D.play()
			
			if current_weapon:
				current_weapon.update_rotation(velocity)
		
		else:
			$AnimatedSprite2D.stop()
			
		return velocity
	else:
		return 0


func _process(delta):
	var velocity = process_movement(delta)

	position += velocity * delta
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		# See the note below about the following boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
		
		
	if Input.is_action_just_pressed("slot_1"):  # Make sure to add this input in Project Settings
		equip_pistol()
	if Input.is_action_just_pressed("slot_2"):
		create_explosion()

func equip_pistol():
	# Remove current weapon if there is one
	if current_weapon:
		current_weapon.queue_free()

	# Load and instance the pistol scene
	var pistol_scene = preload("res://Damageables/Pistol/Pistol.tscn")  # You'll need to create this scene

	current_weapon = pistol_scene.instantiate()
	
	current_weapon.add_modifier("explode")
	current_weapon.add_modifier("spiral")
	current_weapon.add_modifier("multiply")
	weapon_pivot.add_child(current_weapon)
	
	
func create_explosion():
	var explosion_scene = preload("res://Damageables/Explosion/Explosion.tscn")
	var explosion = explosion_scene.instantiate()
	# Place explosion at player position
	explosion.global_position = global_position
	# Add to the game world
	get_tree().root.add_child(explosion)

func _on_body_entered(body):
	hide() 
	hit.emit()
	is_dead = true
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	camera.make_current()
