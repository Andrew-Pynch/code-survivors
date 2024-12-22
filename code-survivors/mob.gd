extends RigidBody2D

var hp = 25

func _ready():
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	
func take_damage(damage):
	print('health', hp, 'damage', damage)
	hp = hp - damage
	
	if hp <= 0:
		queue_free() # destroy mob after death
