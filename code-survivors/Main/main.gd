extends Node

@export var mob_scene: PackedScene
@export var slot_machine_scene: PackedScene

var score

var SPAWN_MOBS = false

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()

func new_game():
	score = 0
	# Init gold for player and connect signals to hud
	$Player.gold = 0
	$Player.gold_updated.connect($HUD.update_gold)

	$Player.start($StartPosition.position)
	$StartTimer.start()
	$ColorRect.hide()

	# Spawn the slot machine near the player
	spawn_slot_machine()
	
	# update hud elements
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	
	get_tree().call_group("mobs", "queue_free")

func spawn_slot_machine():
	var slot_machine = slot_machine_scene.instantiate()

	# Position it near the player's start positional_soft_shadow_filter_set_quality
	var offset = Vector2(100, 0) # 100 pixels to the right
	slot_machine.position = $StartPosition.position + offset
	# Connect the payout signal to the player's gold collection for now
	slot_machine.spin_complete.connect($Player.collect_gold)
	add_child(slot_machine)
	
func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_mob_timer_timeout():
	if SPAWN_MOBS:
		# Create a new instance of the Mob scene.
		var mob = mob_scene.instantiate()

		# Choose a random location on Path2D.
		var mob_spawn_location = $MobPath/MobSpawnLocation
		mob_spawn_location.progress_ratio = randf()

		# Set the mob's direction perpendicular to the path direction.
		var direction = mob_spawn_location.rotation + PI / 2

		# Set the mob's position to a random location.
		mob.position = mob_spawn_location.position

		# Add some randomness to the direction.
		direction += randf_range(-PI / 4, PI / 4)
		mob.rotation = direction

		# Choose the velocity for the mob.
		var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
		mob.linear_velocity = velocity.rotated(direction)
		
		# Connect mob's death signal to player's gold collection 
		mob.mob_died.connect($Player.collect_gold)

		# Spawn the mob by adding it to the Main scene.
		add_child(mob)

func _ready():
	pass
