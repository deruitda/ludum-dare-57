extends Node2D
class_name Drill

@export var battery: Battery
@export var power_consuption_component: PowerConsumptionComponent
@export var drill_resource: DrillResource

@export var drill_speed_factor = 1
@onready var is_actively_drilling: bool = false
@onready var drillable_world_tile_map_player: WorldTileMapLayer
@onready var has_drillable_position_tile: bool = false

@onready var drill_timer: Timer = $DrillTimer

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_player: AudioStreamPlayer2D = $AudioPlayer
@onready var material_break: AudioStreamPlayer2D = $MaterialBreak

@onready var current_direction: Vector2
@onready var drilling_direction: Vector2 

var prev_direction: Vector2
var current_tile_target_coords: Vector2
var current_rid: RID
var prev_rid: RID

signal _on_drilling_aborted
signal _on_drilling_started
signal _on_drilling_finished

func _ready() -> void:
	SignalBus.purchase_completed.connect(_on_purchase_completed)
	animated_sprite_2d.play("idle")
	

func set_current_input_direction(_direction_input: Vector2):
	current_direction = _direction_input
	
func do_drill():
	var space_state = get_world_2d().direct_space_state
	var x_end = global_position.x + (current_direction.x * 10)
	var y_end = global_position.y + (current_direction.y * 10)
	var end_vec = Vector2(x_end, y_end)
	
	var query = PhysicsRayQueryParameters2D.create(global_position, end_vec)
	var result: Dictionary = space_state.intersect_ray(query)
	
	# we aren't colliding with anything
	if !result.has("collider"):
		return
		
	# instantiate world tile map
	var tile_map = result.collider
	
	if tile_map is WorldTileMapLayer:
		drillable_world_tile_map_player = tile_map
			
	# Don't do this if drillable tile map isn't set
	else:
		return
	
	current_rid = result.rid
	
	print("current rid: " + str(current_rid) + "prev rid: " + str(prev_rid))
	
	if is_actively_drilling && (current_direction == Vector2.ZERO || !Helpers.is_a_cardinal_direction(current_direction) || current_direction != prev_direction || current_rid != prev_rid):
		print("changing input while drilling, aborting." + "current: " + str(current_direction) + "prev" + str(prev_direction))
		abort_drilling()
	
	# if not drilling and have a current_direction, start drilling and save the coords from the tile map
	if !is_actively_drilling && Helpers.is_a_cardinal_direction(current_direction):
		current_tile_target_coords = get_drill_target_coodinates(result.rid)
		var tile_resource = drillable_world_tile_map_player.get_tile_resource(current_tile_target_coords)
		
		if not tile_resource is DrillableTileResource:
			return
		print("starting " + "current: " + str(current_direction) + "prev" + str(prev_direction))
		start_drilling(tile_resource, result.rid)
	
	# if drilling and current_direction == prev_direction, return because we are still drilling
	if is_actively_drilling && current_direction == prev_direction:
		print("continuing " + "current: " + str(current_direction) + "prev" + str(prev_direction))
		return
	
	# if drilling and current_direction != prev_direction, abort
	if is_actively_drilling && current_direction != prev_direction:
		print("aborting " + "current: " + str(current_direction) + "prev" + str(prev_direction))
		abort_drilling()

func _physics_process(delta: float) -> void:
	do_drill()

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
	
func start_drilling(tile_resource: TileResource, rid: RID) -> void:
	prev_direction = current_direction
	prev_rid = rid
	current_tile_target_coords = get_drill_target_coodinates(rid)
	print("drilling tile coords: " + str(current_tile_target_coords))
	drill_timer.wait_time = tile_resource.drill_speed / drill_speed_factor
	drill_timer.start()
	drillable_world_tile_map_player.drilling_tile(current_tile_target_coords)
	drill_timer.timeout.connect(_drilling_is_finished)
	
	is_actively_drilling = true
	_on_drilling_started.emit()
	audio_player.play()
	
	animated_sprite_2d.play("start_drilling")

func get_drill_target_coodinates(rid: RID) -> Vector2:
	return drillable_world_tile_map_player.get_coords_for_body_rid(rid)
	
func _drilling_is_finished() -> void:
	print("finish drill")
	if is_actively_drilling == false:
		pass
	is_actively_drilling = false
	
	material_break.play()
	
	var tile_resource = drillable_world_tile_map_player.get_tile_resource(current_tile_target_coords)
	if (tile_resource is ValuableTileResource):
		SignalBus.add_cargo.emit(tile_resource)
		
	drillable_world_tile_map_player.drill_tile(current_tile_target_coords)
	
	animated_sprite_2d.play("end_drilling")
	current_tile_target_coords = Vector2.ZERO
	audio_player.play()


func abort_drilling():
	print("aborting")
	if is_actively_drilling == false:
		pass
	is_actively_drilling = false
	drill_timer.stop()
	drillable_world_tile_map_player.abort_drilling(current_tile_target_coords)
	current_tile_target_coords = Vector2.ZERO
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
		


#func _on_drill_ray_cast_on_collision_exit() -> void:
	#has_drillable_position_tile = false


#func _on_drill_ray_cast_on_collision() -> void:
	#drillable_tile_rid = drill_ray_cast.get_collider_rid()
	#drillable_world_tile_map_player = drill_ray_cast.get_collider()
	#
	#drilling_direction = get_drilling_direction()
	#has_drillable_position_tile = true
