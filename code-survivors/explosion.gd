# Explosion.gd
extends Area2D

@export var damage = 10
@export var lifetime = 0.5  # How long the explosion stays
var time_alive = 0

@export var max_damage = 80
@onready var collision_shape = $CollisionShape2D


func _ready():
	# Start playing animation if you have one
	$Sprite2D.show()
	body_entered.connect(_on_body_entered)
	
func _process(delta):
	time_alive += delta
	if time_alive >= lifetime:
		queue_free()

	# Optional: Add fade out effect
	var alpha = 1 - (time_alive / lifetime)
	modulate.a = alpha

func calculate_distance_damage(distance: float, radius: float) -> float:
	var decayed_radius = radius * 0.8
	
	# If within half radius, return full damage
	if distance <= decayed_radius:
		return max_damage
		
	# Calculate falloff for distances beyond half radius
	var falloff_distance = distance - decayed_radius
	var max_falloff_distance = radius - decayed_radius
	var damage_reduction = clamp(falloff_distance / max_falloff_distance, 0.0, 1.0)
	
	# Calculate final damage and ensure it's between min and max
	var final_damage = lerp(max_damage, damage, damage_reduction)
	return clamp(final_damage, damage, max_damage)


func _on_body_entered(body):
	if body.is_in_group("mobs"):
		var distance = global_position.distance_to(body.global_position)
		var radius = collision_shape.shape.radius
		var final_damage = calculate_distance_damage(distance, radius)
		
		if body.has_method("take_damage"):
			body.take_damage(round(final_damage))
