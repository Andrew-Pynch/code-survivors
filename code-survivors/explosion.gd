# Explosion.gd
extends Area2D

@export var damage = 10
@export var lifetime = 0.5  # How long the explosion stays
var time_alive = 0

func _ready():
	# Start playing animation if you have one
	$Sprite2D.show()
	
func _process(delta):
	time_alive += delta
	if time_alive >= lifetime:
		queue_free()

	# Optional: Add fade out effect
	var alpha = 1 - (time_alive / lifetime)
	modulate.a = alpha
