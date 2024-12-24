extends ColorRect

func _ready():
	material = ShaderMaterial.new()
	material.shader = preload("res://Shaders/retro_filter.gdshader")
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	# Make it cover the full viewport
	anchor_right = 1  # Stretch to right edge
	anchor_bottom = 1  # Stretch to bottom edge
	offset_right = 0  # No additional offset needed
	offset_bottom = 0
