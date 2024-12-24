extends Area2D

signal chest_opened(gold_amount: int)

@onready var interaction_text = $InteractionText
@onready var sprite = $ColorRect
var is_player_nearby = false

func _ready():
	add_to_group("chests")
	interaction_text.hide()
	# Set initial color
	sprite.color = Color(0.7, 0.5, 0.3) # Brown color for chest
	sprite.color.a = 1.0 # Full opacity
	
func _process(_delta):
	if is_player_nearby and Input.is_action_just_pressed("interact"):
		open_chest()

func open_chest():
	var gold_amount = randi_range(10, 50)
	emit_signal("chest_opened", gold_amount)
	queue_free()

# Change from body_entered to area_entered
func _on_area_entered(area: Area2D):
	if area.is_in_group("player"):
		is_player_nearby = true
		interaction_text.show()
		sprite.color = Color(1.0, 0.8, 0.4) # Highlight color

# Change from body_exited to area_exited
func _on_area_exited(area: Area2D):
	if area.is_in_group("player"):
		is_player_nearby = false
		interaction_text.hide()
		sprite.color = Color(0.7, 0.5, 0.3) # Return to original color
