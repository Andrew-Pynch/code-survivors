extends BaseProjectile

@export var damage = 25

func _ready():
	body_entered.connect(_on_body_entered)
	# Find and categorize all modifier nodes
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
		var final_damage = damage
		var should_pierce = false
		
		# Apply hit modifiers
		for modifier in hit_modifiers:
			var result = modifier.modify_hit(body, final_damage)
			final_damage = result.damage
			should_pierce = result.pierce or should_pierce
		
		if body.has_method("take_damage"):
			var previous_health = body.health
			body.take_damage(final_damage)
			
			if body.health <= 0:
				# Apply death modifiers
				for modifier in death_modifiers:
					modifier.on_kill(body)
		
		if not should_pierce:
			queue_free()
