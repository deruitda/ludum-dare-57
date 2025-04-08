extends Node2D

@export var ping_time: int = 5
@onready var timer: Timer = $Timer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var light_color: Color = Color.WHITE
var target_position: Vector2
var is_offscreen := false

func _ready():
	start_ping()

func _on_timer_timeout():
	queue_free()

func start_ping():
	timer.start(ping_time)
	audio_stream_player_2d.play()

func _physics_process(_delta):
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
		var edge_padding = 32.0
		var clamped_pos = target_position.clamp(
			top_left + Vector2(edge_padding, edge_padding),
			bottom_right - Vector2(edge_padding, edge_padding)
		)

		global_position = clamped_pos
		look_at(target_position)
	else:
		global_position = target_position

	queue_redraw()

func _draw():
	if is_offscreen:
		var points = [
			Vector2(0, -10),
			Vector2(6, 10),
			Vector2(-6, 10)
		]
		draw_polygon(points, [light_color])
