# Background.gd
extends ParallaxBackground

@onready var background = $ParallaxLayer/Background
var is_visible = false

func _ready():
	hide()  # Start hidden

func start():
	show()
