extends Node

@export var mob_scene: PackedScene
@export var chest_scene: PackedScene

var score

var chest_min_amount = 3
var chest_max_amount = 7

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
	$CursedPlains.start()

	# Spawn chests
	spawn_chests()
	
	# update hud elements
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	
	get_tree().call_group("mobs", "queue_free")
	
func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_mob_timer_timeout():
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

func spawn_chests():
	if not chest_scene:
		print("ERROR: Chest scene not set!")
		return
		
	var num_chests = randi_range(chest_min_amount, chest_max_amount)
	print("Attempting to spawn ", num_chests, " chests")
	
	var spawn_radius = 500
	var min_distance = 200
	var spawn_center = $StartPosition.position
	var spawned_positions = []
	
	for i in range(num_chests):
		var valid_position = false
		var new_pos = Vector2.ZERO
		var attempts = 0
		var max_attempts = 50
		
		while !valid_position and attempts < max_attempts:
			var angle = randf() * PI * 2
			var distance = randf_range(min_distance, spawn_radius)
			new_pos = spawn_center + Vector2(cos(angle), sin(angle)) * distance
			
			valid_position = true
			for pos in spawned_positions:
				if new_pos.distance_to(pos) < min_distance:
					valid_position = false
					break
			
			attempts += 1
		
		if valid_position:
			var chest = chest_scene.instantiate()
			chest.position = new_pos
			chest.z_index = 1  # Ensure it's above background
			# Connect using proper signal handling
			chest.connect("chest_opened", $Player.collect_gold)
			add_child(chest)
			spawned_positions.append(new_pos)
			print("Spawned chest at: ", new_pos)
