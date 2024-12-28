class_name ExplodeOnKillModifier
extends ProjectileModifier

@export var explosion_radius = 100.0
@export var explosion_damage = 50

func _init():
	modifier_type = "death"

func on_kill(target):
	var explosion_scene = preload("res://Damageables/Explosion/Explosion.tscn")
	var explosion = explosion_scene.instantiate()
	explosion.global_position = target.global_position
	explosion.damage = explosion_damage
	explosion.get_node("CollisionShape2D").shape.radius = explosion_radius
	projectile.get_tree().root.add_child(explosion)
