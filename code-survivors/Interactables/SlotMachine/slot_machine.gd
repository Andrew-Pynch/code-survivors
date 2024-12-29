extends StaticBody2D

signal spin_complete(payout)

@export var spin_cost = 0  
@export var min_payout = 5
@export var max_payout = 100
var can_interact = false
var is_spinning = false
var player_detector: Area2D

func _ready():
	# Add to a group if you want to manage all slot machines
	add_to_group("interactables")
	add_to_group("slot_machines")
	
	# Create an Area2D child for player detection
	player_detector = Area2D.new()
	var collision_shape = CollisionShape2D.new()
	# Make the detection area slightly larger than the slot machine's collision
	var shape = CircleShape2D.new()
	shape.radius = 50  # Adjust this value as needed
	collision_shape.shape = shape
	
	player_detector.add_child(collision_shape)
	add_child(player_detector)
	
	# Connect the detection area signals
	player_detector.area_entered.connect(_on_player_detector_area_entered)
	player_detector.area_exited.connect(_on_player_detector_area_exited)

func _input(event):
	if can_interact and Input.is_action_just_pressed("interact"):
		print("Interaction detected!")  # Debug print
		if not is_spinning:
			start_spin()

func _on_player_detector_area_entered(area):
	if area.is_in_group("player"):
		print("DETECTED PLAYER ENTERING")
		can_interact = true
		# Show interaction prompt

func _on_player_detector_area_exited(area):
	if area.is_in_group("player"):
		print("DETECTED PLAYER LEAVING")
		can_interact = false
		# Hide interaction prompt

func start_spin():
	print("Starting spin!")  # Debug print
	is_spinning = true
	print("SPINNING...")  # Show spinning state
	await get_tree().create_timer(2.0).timeout
	complete_spin()

func complete_spin():
	is_spinning = false
	var payout = randi_range(min_payout, max_payout)
	print("YOU WIN: ", payout, " GOLD!")  # Show win amount
	emit_signal("spin_complete", payout)
