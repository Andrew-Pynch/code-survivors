# Bullet.gd
extends Area2D

var speed = 600
var direction = Vector2.RIGHT  # Will be set by the gun

func _process(delta):
	position += direction * speed * delta

# Optional: Delete bullet when it goes off screen
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
