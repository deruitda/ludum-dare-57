extends Node2D
class_name Drill

@export var battery: Battery
@export var power_consuption_component: PowerConsumptionComponent
@export var drill_resource: DrillResource

@onready var is_actively_drilling: bool = false
@onready var drillable_tile_rid: RID
@onready var drillable_world_tile_map_player: WorldTileMapLayer
@onready var has_drillable_position_tile: bool = false

@onready var drill_timer: Timer = $DrillTimer
@onready var drill_ray_cast: RayCastCollider = $DrillRayCast

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D		
@onready var audio_listener_2d: AudioStreamPlayer2D = $AudioListener2D

@onready var current_direction_input: Vector2
@onready var drilling_direction: Vector2

@onready var is_colliding: bool = false

signal _on_drilling_aborted
signal _on_drilling_started
signal _on_drilling_finished

func _ready() -> void:
	animated_sprite_2d.play("idle")

func set_current_input_direction(_direction_input: Vector2):
	current_direction_input = _direction_input

func _physics_process(delta: float) -> void:
	set_colliding_state()
	
	if drill_ray_cast.is_colliding():
		#var tile_resource = drill_ray_cast.get_collider().get_tile_resource_from_rid(drill_ray_cast.get_collider_rid())
		#if  tile_resource is DrillableTileResource and drilling_direction == get_drilling_direction():
		if drilling_direction == get_drilling_direction():
			
			if is_actively_drilling:
				battery.consume_power(power_consuption_component.power_consumption_per_use * delta)
			else:
				start_drilling()

	if drilling_direction != get_drilling_direction() and is_actively_drilling:
		# We've turned somewhere
		abort_drilling()
		
	#if  (not current_direction_input == Vector2.ZERO) and current_direction_input == drilling_direction and has_drillable_position_tile:
		#if is_actively_drilling:
		#elif not is_actively_drilling:
			#start_drilling()
	#else:
		#if is_actively_drilling:
			#abort_drilling()
func set_colliding_state():
	is_colliding = drill_ray_cast.is_colliding()
		
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
	drillable_world_tile_map_player = drill_ray_cast.get_collider()
	drillable_tile_rid = drill_ray_cast.get_collider_rid()
	var tile_resource = drillable_world_tile_map_player.get_tile_resource_from_rid(drillable_tile_rid)
	if not tile_resource is DrillableTileResource:
		return
	drill_timer.wait_time = tile_resource.drill_speed
	drill_timer.start()
	drill_timer.timeout.connect(_drilling_is_finished)
	
	is_actively_drilling = true
	_on_drilling_started.emit()
	
	animated_sprite_2d.play("start_drilling")


func _drilling_is_finished() -> void:
	if is_actively_drilling == false:
		pass
	is_actively_drilling = false
	
	var tile_resource = drillable_world_tile_map_player.get_tile_resource_from_rid(drillable_tile_rid)
	if (tile_resource is ValuableTileResource):
		SignalBus.add_cargo.emit(drill_resource)
		
	drillable_world_tile_map_player.drill_tile(drillable_tile_rid)
	
	animated_sprite_2d.play("end_drilling")
	audio_listener_2d.play()


func abort_drilling():
	print("abort drilling")
	has_drillable_position_tile = false
	drill_timer.stop()
	is_actively_drilling = false
	_on_drilling_aborted.emit()
	if animated_sprite_2d.animation == "active_drilling":
		animated_sprite_2d.play("end_drilling")


func _on_animated_sprite_2d_animation_finished() -> void:
	print(animated_sprite_2d.animation)
	if is_actively_drilling:
		animated_sprite_2d.play("active_drilling")
	elif animated_sprite_2d.animation == "active_drilling" or animated_sprite_2d.animation == "start_drilling":
		animated_sprite_2d.play("end_drilling")
	elif animated_sprite_2d.animation == "end_drilling":
		
		animated_sprite_2d.play("idle")
		animated_sprite_2d.stop()
		


func _on_drill_ray_cast_on_collision_exit() -> void:
	has_drillable_position_tile = false


func _on_drill_ray_cast_on_collision() -> void:
	drillable_tile_rid = drill_ray_cast.get_collider_rid()
	drillable_world_tile_map_player = drill_ray_cast.get_collider()
	
	drilling_direction = get_drilling_direction()
	has_drillable_position_tile = true
