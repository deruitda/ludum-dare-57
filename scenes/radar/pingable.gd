extends Node2D
class_name Pingable

@export var ping_time: int = 5

@onready var light: PointLight2D = $PointLight2D
@onready var timer: Timer = $Timer
func ping():
	start_ping()

func _on_timer_timeout() -> void:
	stop_ping()

func start_ping():
	timer.start(ping_time)
	light.enabled = true
	
func stop_ping():
	light.enabled = false
