extends Node2D
class_name Ping

@export var ping_time: int = 5
@onready var light: PointLight2D = $PointLight2D
@onready var timer: Timer = $Timer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

@onready var _ping_global_position: Vector2

var light_color: Color = Color.WHITE

func _ready() -> void:
	start_ping()

func _on_timer_timeout() -> void:
	stop_ping()

func start_ping():
	timer.start(ping_time)
	light.color = light_color
	light.enabled = true
	audio_stream_player_2d.play()
	
func stop_ping():
	self.queue_free()
