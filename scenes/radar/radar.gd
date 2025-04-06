extends Node2D

@export var max_radius: float = 500
@export var min_radius: float = 0
@export var increment: float = 10
@export var cooldown_time: int = 5

@export var battery: Battery
@onready var power_consumption_component: PowerConsumptionComponent = $PowerConsumptionComponent

@onready var timer: Timer = $Timer
@onready var circle_collider: CollisionShape2D = $Area2D/CollisionShape2D
@onready var area2d : Area2D = $Area2D
@onready var circle_drawer: CircleDrawer = $CircleDrawer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var is_scanning = false
var is_cooling_down = false
var current_rad: float

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_R and !is_scanning and !animated_sprite.is_playing():
			start_scan()

func _physics_process(_delta):
	
	if is_scanning:
		
		if animated_sprite.is_playing() && animated_sprite.animation == "begin_scan":
			return
		else:
			animated_sprite.play("blink")
		
		current_rad = circle_collider.shape.radius
		var new_rad = 0
	
		if current_rad <= max_radius:
			new_rad = current_rad + increment
		else:
			is_scanning = false
			circle_drawer.visible = false
			area2d.monitoring = false
			animated_sprite.play("end_scan")

		current_rad = new_rad
		circle_collider.shape.radius = current_rad

		circle_drawer.circle_draw(current_rad)

func start_scan():
	if not battery.has_enough_power_for(power_consumption_component.power_consumption_per_use):
		reject_scan_for_lack_of_power()
		pass
	battery.consume_power(power_consumption_component.power_consumption_per_use)
	animated_sprite.play("begin_scan")
	is_scanning = true
	circle_drawer.visible = true
	area2d.monitoring = true

func reject_scan_for_lack_of_power() -> void:
	pass

func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if !body is WorldTileMapLayer:
		pass
	
	var test = body.get_coords_for_body_rid(body_rid)
	var coords = body.get_tile_global_position(body_rid)
	var tile_resource = body.get_tile_resource_from_rid(body_rid)
	SignalBus.resource_pinged.emit(coords, tile_resource)
