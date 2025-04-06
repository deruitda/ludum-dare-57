extends Node
class_name MoveToCenterComponent

@export var move_to_center_speed = 400
@export var move_to_center_velocity_threshold = 0.1

@export var move_to_center_countdown_timer: Timer

@onready var current_velocity: Vector2 = Vector2.ZERO
@onready var current_input_direction: Vector2
@onready var current_position: Vector2

@onready var must_move_to_center: bool = false
@onready var is_currently_centering: bool = false

func _ready() -> void:
	move_to_center_countdown_timer.timeout.connect(_on_move_to_center_countdown_timer_timeout)

func _process(delta: float) -> void:
	if is_currently_centering and (current_input_direction > Vector2.ZERO or is_in_center(current_position)):
		print(is_in_center(current_position))
		is_currently_centering = false
	elif is_currently_centering:
		pass
	
	if get_could_move_to_center_based_on_inputs() :
		start_timer()
	else:
		cancel_timer()
		
func get_could_move_to_center_based_on_inputs() -> bool:
	if current_velocity.length() > move_to_center_velocity_threshold:
		return false
	# Check if the body is not moving
	if current_input_direction > Vector2.ZERO:
		return false
	
	if is_in_center(current_position):
		return false

	return true

func start_timer() -> void:
	if move_to_center_countdown_timer.paused or move_to_center_countdown_timer.is_stopped():
		#print("starting timer")
		move_to_center_countdown_timer.start()
	else:
		pass
		#print ("start timer is  paused")
		
	

func cancel_timer() -> void:
	if not move_to_center_countdown_timer.paused or not move_to_center_countdown_timer.is_stopped():
		move_to_center_countdown_timer.stop()
		#print("cancelling timer")

func is_in_center(_position: Vector2):
	return get_closest_center(_position) == _position

func get_velocity_to_center() -> Vector2:
	must_move_to_center = false
	
	var tile_size = GameState.PIXEL_SIZE
	# Get the current tile position in tile coordinates
	
	# Get the center of that tile in pixel space
	var center_position: Vector2 = get_position_lerped_to_center(current_position, 0.2)
	var direction = center_position - current_position
	
	if direction.length() < 1.0:
		return Vector2.ZERO  # Close enough to center, stop moving
		
	var desired_velocity = direction.normalized() * move_to_center_speed

	return current_velocity.lerp(desired_velocity, 0.1)  # smooth it out

func get_position_lerped_to_center(position: Vector2, lerp_amount: float) -> Vector2:
	var center = get_closest_center(position)
	if position.distance_to(center) < 1.0:
		return center
	return position.lerp(center, lerp_amount)

func set_current_velocity(velocity: Vector2) -> void:
	# Set the current velocity of the body
	current_velocity = velocity
	
func set_current_position_value(position: Vector2):
	current_position = position

func set_current_input_direction(input_direction: Vector2) -> void:
	current_input_direction = input_direction
	
func _get_velocity_to_center(_position: Vector2, speed_to_center: float) -> Vector2:
	var tile_size = GameState.PIXEL_SIZE
	# Get the current tile position in tile coordinates
	
	# Get the center of that tile in pixel space
	var center_position: Vector2 = get_closest_center(_position)
	var direction = center_position - _position
	var desired_velocity = direction.normalized() * speed_to_center

	return current_velocity.lerp(desired_velocity, 0.1)  # smooth it out

	
func get_closest_center(_position: Vector2) -> Vector2:
	var tile_size = GameState.PIXEL_SIZE  # Should be 64 based on your tilemap
	var tile_coords = (_position / tile_size).floor()
	var center = (tile_coords + Vector2(0.5, 0.5)) * tile_size
	return center


func _on_move_to_center_countdown_timer_timeout() -> void:
	#print ("timeout")
	must_move_to_center = true
	is_currently_centering = true
	move_to_center_countdown_timer.stop()
	
