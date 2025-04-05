extends Node2D

@export var max_radius: float = 500
@export var min_radius: float = 0
@export var increment: float = 10
@export var cooldown_time: int = 5
@onready var timer: Timer = $Timer
@onready var circle_collider: CollisionShape2D = $Area2D/CollisionShape2D
@onready var circle_drawer: CircleDrawer = $CircleDrawer

var is_scanning = false
var is_cooling_down = false
var current_rad: float

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_R and !is_scanning and !is_cooling_down:
			start_scan()

func _physics_process(delta):
	
	if is_scanning:
		current_rad = circle_collider.shape.radius
		var new_rad = 0
	
		if current_rad <= max_radius:
			new_rad = current_rad + increment
		else:
			is_scanning = false
			circle_drawer.visible = false
			is_cooling_down = true
			timer.start(cooldown_time)

		current_rad = new_rad
		circle_collider.shape.radius = current_rad

		circle_drawer.circle_draw(current_rad)

func start_scan():
	is_scanning = true
	circle_drawer.visible = true


func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if !body is WorldTileMapLayer:
		pass
	
	var test = body.get_coords_for_body_rid(body_rid)
	var coords = body.get_tile_global_position(body_rid)
	var tile_resource = body.get_tile_resource_from_rid(body_rid)
	SignalBus.resource_pinged.emit(coords, tile_resource)


func _on_timer_timeout() -> void:
	is_cooling_down = false
