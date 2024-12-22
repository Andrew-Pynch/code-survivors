# Bullet.gd
extends Area2D

var speed = 600
var direction = Vector2.RIGHT  # Will be set by the gun
@export var damage = 25  

func _process(delta):
	position += direction * speed * delta

# Optional: Delete bullet when it goes off screen
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	print("bullet hit something")
	if body.has_method("take_damage"):  
		body.take_damage(damage)    # Call the take_damage method with our damage amount
	queue_free()  # Destroy the bullet after hitting something	
