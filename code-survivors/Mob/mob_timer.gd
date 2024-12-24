extends Timer

@onready var game_timer = get_node("/root/Main/ScoreTimer")
var elapsed_time = 0
var last_speedup = 0
var speedup_interval = 10  # Speedup every 10 seconds

func _ready() -> void:
	wait_time = 2

func _process(delta: float) -> void:
	elapsed_time += delta
	spawn_director()

func spawn_director():
	# Check if enough time has passed since last speedup
	if elapsed_time - last_speedup >= speedup_interval && wait_time > 0.5:
		wait_time = wait_time/2
		last_speedup = elapsed_time
