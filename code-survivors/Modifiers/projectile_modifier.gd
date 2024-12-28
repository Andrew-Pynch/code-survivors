extends Node

class_name ProjectileModifier

enum ModifierType { HIT, MOVEMENT, SPAWN, DEATH }

@export var modifier_type: String = "hit"  # hit, movement, spawn, death
var projectile: BaseProjectile

func initialize(parent_projectile: BaseProjectile):
	projectile = parent_projectile

func modify_hit(target, damage) -> Dictionary:
	return {
		"damage": damage,
		"pierce": false
	}

func modify_movement(current_direction: Vector2, current_speed: float, delta: float) -> Dictionary:
	return {
		"direction": current_direction,
		"speed": current_speed
	}

func on_kill(target):
	pass
