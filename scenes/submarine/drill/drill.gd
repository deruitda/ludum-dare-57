extends Node2D
class_name Drill

@export var battery: Battery
@export var power_consuption_component: PowerConsumptionComponent
@export var drill_resource: DrillResource

@export var drill_speed_factor = 1
@onready var is_actively_drilling: bool = false
@onready var drillable_tile_rid: RID
@onready var drillable_world_tile_map_player: WorldTileMapLayer
@onready var has_drillable_position_tile: bool = false

@onready var drill_timer: Timer = $DrillTimer
@onready var drill_ray_cast: RayCastCollider = $DrillRayCast

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D		
@onready var audio_player: AudioStreamPlayer2D = $AudioPlayer
@onready var material_break: AudioStreamPlayer2D = $MaterialBreak

@onready var current_direction_input: Vector2
@onready var drilling_direction: Vector2
@onready var current_velocity: Vector2
@onready var velocity_threshold: float = 100.0

signal _on_drilling_aborted
signal _on_drilling_started
signal _on_drilling_finished

func _ready() -> void:
	SignalBus.purchase_completed.connect(_on_purchase_completed)
	animated_sprite_2d.play("idle")

func set_current_input_direction(_direction_input: Vector2):
	current_direction_input = _direction_input

func set_current_velocity(_velocity: Vector2):
	current_velocity = _velocity

func _physics_process(delta: float) -> void:
	var input_is_valid = current_direction_input.length() > 0.0 and Helpers.is_a_cardinal_direction(current_direction_input)
	var drilling_and_original_direction_is_the_same = get_drilling_direction() == drilling_direction and drillable_tile_rid == drill_ray_cast.get_collider_rid()
	var is_going_too_fast: bool = is_perpendicular_velocity_too_fast()
	if drill_ray_cast.is_colliding() and drill_ray_cast.get_collider() is WorldTileMapLayer:
		
		if input_is_valid and drilling_and_original_direction_is_the_same:
			if is_actively_drilling:
				battery.consume_power(power_consuption_component.power_consumption_per_use * delta)
			elif not is_going_too_fast:
				start_drilling()
		elif is_actively_drilling:
			print("aborting because actively drilling")
			abort_drilling()
		elif input_is_valid and not drilling_and_original_direction_is_the_same and not is_going_too_fast:
			print("starting because input is valid and direction is same")
			start_drilling()
	elif is_actively_drilling:
		print("aborting because not colliding anymore")
		abort_drilling()
	
	if not input_is_valid and is_actively_drilling:
		print("aborting because invalid input")
		abort_drilling()

func is_perpendicular_velocity_too_fast() -> bool:
	# Find the perpendicular direction
	var perpendicular_direction = Vector2(-current_direction_input.y, current_direction_input.x).normalized()

	# Get the velocity component in the perpendicular direction
	var perpendicular_velocity = current_velocity.dot(perpendicular_direction)

	# Check if the perpendicular velocity exceeds the threshold
	return abs(perpendicular_velocity) > velocity_threshold

func _on_purchase_completed(purchased_shop_item_resource: ShopItemResource) -> void:
	if purchased_shop_item_resource.item_resource is DrillResource:
		drill_resource = purchased_shop_item_resource.item_resource
		drill_speed_factor = drill_resource.speed_factor

func get_drilling_direction() -> Vector2:
	# Default direction (90 degrees to the left, which is -90 degrees)
	var default_direction = Vector2(0.0, -1.0)  # Upward direction in the local coordinate system
	
	# Rotate the direction by the given rotation
	var _direction = default_direction.rotated(global_rotation)

	# Round the vector components to remove small precision errors
	_direction.x = Helpers.round_to_dec(_direction.x, 3)  # Round x to 3 decimal places (or adjust as needed)
	_direction.y = Helpers.round_to_dec(_direction.y, 3)  # Round x to 3 decimal places (or adjust as needed)

	# Return the resulting direction
	return _direction
	
func start_drilling() -> void:
	print("start drill")
	drillable_world_tile_map_player = drill_ray_cast.get_collider()
	drillable_tile_rid = drill_ray_cast.get_collider_rid()
	drilling_direction = get_drilling_direction()
	var tile_resource = drillable_world_tile_map_player.get_tile_resource_from_rid(drillable_tile_rid)
	if not tile_resource is DrillableTileResource:
		return
	drill_timer.wait_time = tile_resource.drill_speed / drill_speed_factor
	drill_timer.start()
	drillable_world_tile_map_player.drilling_tile(drillable_tile_rid)
	drill_timer.timeout.connect(_drilling_is_finished)
	
	is_actively_drilling = true
	_on_drilling_started.emit()
	audio_player.play()
	
	animated_sprite_2d.play("start_drilling")

func _drilling_is_finished() -> void:
	print("finish drill")
	if is_actively_drilling == false:
		pass
	is_actively_drilling = false
	
	material_break.play()
	
	var tile_resource = drillable_world_tile_map_player.get_tile_resource_from_rid(drillable_tile_rid)
	if (tile_resource is ValuableTileResource):
		SignalBus.add_cargo.emit(tile_resource)
		
	drillable_world_tile_map_player.drill_tile(drillable_tile_rid)
	
	animated_sprite_2d.play("end_drilling")
	audio_player.play()


func abort_drilling():
	print("aborting")
	if is_actively_drilling == false:
		pass
	is_actively_drilling = false
	drill_timer.stop()
	drillable_world_tile_map_player.abort_drilling(drillable_tile_rid)
	_on_drilling_aborted.emit()
	if animated_sprite_2d.animation == "active_drilling":
		animated_sprite_2d.play("end_drilling")


func _on_animated_sprite_2d_animation_finished() -> void:
	if is_actively_drilling:
		animated_sprite_2d.play("active_drilling")
	elif animated_sprite_2d.animation == "active_drilling" or animated_sprite_2d.animation == "start_drilling":
		animated_sprite_2d.play("end_drilling")
	elif animated_sprite_2d.animation == "end_drilling":
		audio_player.stop()
		animated_sprite_2d.play("idle")
		animated_sprite_2d.stop()
		


func _on_drill_ray_cast_on_collision_exit() -> void:
	has_drillable_position_tile = false


func _on_drill_ray_cast_on_collision() -> void:
	drillable_tile_rid = drill_ray_cast.get_collider_rid()
	drillable_world_tile_map_player = drill_ray_cast.get_collider()
	
	drilling_direction = get_drilling_direction()
	has_drillable_position_tile = true
