# DamageNumber.gd
extends Node2D

@onready var label = $Label
var damage_value = 0
var float_speed = 50
var fade_speed = 0.5
var time_alive = 0

func _ready():
	label.text = str(damage_value)
	
func _process(delta):
	# Move up
	position.y -= float_speed * delta
	
	# Fade out
	time_alive += delta
	modulate.a = 1 - (time_alive / fade_speed)
	
	# Remove when fully faded
	if time_alive >= fade_speed:
		queue_free()
