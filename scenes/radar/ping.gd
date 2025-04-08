extends Node2D
class_name Ping

@export var ping_time: int = 5
@onready var light: PointLight2D = $PointLight2D
@onready var timer: Timer = $Timer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

const FULL_BOX_PING_LIGHT_TEXTURE = preload("res://scenes/radar/radar_resources/full_box_ping_light_texture.tres")
const OFF_SCREEN_CIRCLE_PING_LIGHT_TEXTURE = preload("res://scenes/radar/radar_resources/off_screen_circle_ping_light_texture.tres")

@export var target_position: Vector2 = Vector2.ZERO
var light_color: Color = Color.WHITE
var is_offscreen: bool = false
const ONSCREEN_SCALE = Vector2.ONE
const OFFSCREEN_SCALE = Vector2.ONE * 0.9
func _ready() -> void:
	global_position = target_position
	start_ping()

func _physics_process(_delta: float) -> void:
	var camera := get_viewport().get_camera_2d()
	if camera == null:
		return

	var camera_pos = camera.global_position
	var viewport_size = get_viewport().get_visible_rect().size
	var half_view = viewport_size / 2.0
	var top_left = camera_pos - half_view
	var bottom_right = camera_pos + half_view
	var screen_rect = Rect2(top_left, viewport_size)

	is_offscreen = not screen_rect.has_point(target_position)

	if is_offscreen:
		global_position = target_position.clamp(top_left + Vector2.ONE * 16.0, bottom_right - Vector2.ONE * 16.0)
		light.texture = OFF_SCREEN_CIRCLE_PING_LIGHT_TEXTURE

		# Distance from camera
		var distance = camera_pos.distance_to(target_position)

		# Optional: define a range for fading
		var min_distance = 0.0  # close to camera
		var max_distance = 10000 # far away
		var clamped_distance = clamp(distance, min_distance, max_distance)

		# Interpolate brightness: close = dim, far = bright
		var t = inverse_lerp(min_distance, max_distance, clamped_distance)
		light.energy = lerp(0.1, 0.6, t)
	else:
		global_position = target_position
		light.texture = FULL_BOX_PING_LIGHT_TEXTURE
		#light.range = 128  # full size when onscreen
		light.energy = 1.0  # full brightness

func _on_timer_timeout() -> void:
	stop_ping()

func start_ping():
	timer.start(ping_time)
	light.color = light_color
	light.enabled = true
	audio_stream_player_2d.play()
	
func stop_ping():
	queue_free()
