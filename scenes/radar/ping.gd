extends Node2D
class_name Ping

@export var ping_time: int = 5
@onready var light: PointLight2D = $PointLight2D
@onready var timer: Timer = $Timer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var target_position: Vector2 = Vector2.ZERO
var light_color: Color = Color.WHITE

func _ready() -> void:
	global_position = target_position
	start_ping()

func _physics_process(_delta: float) -> void:
	var camera := get_viewport().get_camera_2d()
	if camera == null:
		return

	var viewport_size = get_viewport().get_visible_rect().size
	var half_view = viewport_size / 2.0
	var camera_pos = camera.global_position
	var top_left = camera_pos - half_view
	var bottom_right = camera_pos + half_view
	var screen_rect = Rect2(top_left, viewport_size)

	if screen_rect.has_point(target_position):
		global_position = target_position
	else:
		global_position = target_position.clamp(top_left, bottom_right)

func _on_timer_timeout() -> void:
	stop_ping()

func start_ping():
	timer.start(ping_time)
	light.color = light_color
	light.enabled = true
	audio_stream_player_2d.play()
	
func stop_ping():
	queue_free()
