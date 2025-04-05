extends Node2D

@export var max_radius: float = 500
@export var min_radius: float = 0
@export var increment: float = 10
@export var time_interval: int = 5
@onready var timer: Timer = $Timer
@onready var circle_collider: CollisionShape2D = $Area2D/CollisionShape2D

var is_scanning = false

func _physics_process(delta):
	
	if is_scanning:
		var current_rad = circle_collider.shape.radius
		var new_rad = 0
	
		if current_rad <= max_radius:
			new_rad = current_rad + increment
		else:
			timer.start(time_interval)
			is_scanning = false

		circle_collider.shape.radius = new_rad
func _ready() -> void:
	pass # Replace with function body.



func _on_timer_timeout() -> void:
	is_scanning = true
