extends Area2D
class_name BaseProjectile

# Base properties
var base_damage = 10
var speed = 700
var direction = Vector2.RIGHT

# Modifier nodes (will be filled by attached modifiers)
var hit_modifiers = []
var movement_modifiers = []
var spawn_modifiers = []
var death_modifiers = []

# Projectile state
var source_projectile = null  # For tracking what created this projectile
var killed_enemy = false  # Track if this projectile killed an enemy

func _ready():
	body_entered.connect(_on_body_entered)
	# Initialize all modifier nodes
	for child in get_children():
		if child is ProjectileModifier:
			match child.modifier_type:
				"hit": hit_modifiers.append(child)
				"movement": movement_modifiers.append(child)
				"spawn": spawn_modifiers.append(child)
				"death": death_modifiers.append(child)
			child.initialize(self)

func _physics_process(delta):
	# Apply movement modifiers
	var modified_direction = direction
	var modified_speed = speed
	
	for modifier in movement_modifiers:
		var result = modifier.modify_movement(modified_direction, modified_speed, delta)
		modified_direction = result.direction
		modified_speed = result.speed
	
	global_position += modified_direction * modified_speed * delta

func _on_body_entered(body):
	if body.is_in_group("mobs"):
		var final_damage = base_damage
		var should_pierce = false
		
		# Apply hit modifiers
		for modifier in hit_modifiers:
			var result = modifier.modify_hit(body, final_damage)
			final_damage = result.damage
			should_pierce = result.pierce or should_pierce
		
		if body.has_method("take_damage"):
			var previous_health = body.health
			body.take_damage(final_damage)
			killed_enemy = body.health <= 0
			
			# Apply death modifiers if we killed the enemy
			if killed_enemy:
				for modifier in death_modifiers:
					modifier.on_kill(body)
		
		if not should_pierce:
			queue_free()
