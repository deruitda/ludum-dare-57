extends Node

var ping_scene = preload("res://scenes/radar/ping.tscn")

func _ready() -> void:
	SignalBus.resource_pinged.connect(spawn_ping)
	
func spawn_ping(coords: Vector2, tile_resource: ValuableTileResource):
	var camera := get_viewport().get_camera_2d()
	if camera == null:
		push_warning("No camera found")
		return

	var instance = ping_scene.instantiate() as Ping
	instance.light_color = tile_resource.ping_color

	var viewport_size = get_viewport().get_visible_rect().size
	var half_view = viewport_size / 2.0
	var camera_pos = camera.global_position

	# Calculate screen bounds (world-space rect)
	var top_left = camera_pos - half_view
	var bottom_right = camera_pos + half_view
	var screen_rect = Rect2(top_left, viewport_size)

	if screen_rect.has_point(coords):
		instance.global_position = coords
	else:
		# Clamp position to screen edges
		var clamped_coords = coords.clamp(top_left, bottom_right)
		instance.global_position = clamped_coords

	get_tree().root.add_child(instance)
