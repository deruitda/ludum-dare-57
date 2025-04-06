extends CharacterBody2D
@export var speed = 400

@export var move_to_center_component: MoveToCenterComponent

@export var velocity_component: VelocityComponent
@export var edge_detector: EdgeDetector
@export var hull: Hull
@export var drill: Drill

@onready var current_depth: float
@onready var direction_input: Vector2 = Vector2.ZERO


func _process(delta: float) -> void:
	direction_input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	current_depth = global_position.y / GameState.PIXEL_SIZE
	
	SignalBus.set_current_depth.emit(current_depth)

func _physics_process(delta: float):
	drill.set_current_input_direction(direction_input)
	
	move_to_center_component.set_current_position_value(global_position)
	move_to_center_component.set_current_velocity(velocity)
	
	if drill.is_actively_drilling:
		#print ("is actively drilling")
		move_to_center_component.set_current_input_direction(Vector2.ZERO)
	else:
		move_to_center_component.set_current_input_direction(direction_input)
	
	hull.update_depth(current_depth, delta)
	apply_rotation()
	velocity_component.set_current_rotation(rotation_degrees)
	
	if move_to_center_component.is_currently_centering:
		var move_to_center_velocity: Vector2 = move_to_center_component.get_velocity_to_center()
		velocity_component.set_velocity(move_to_center_velocity)
	elif not drill.is_actively_drilling:
		velocity_component.apply_move(direction_input, delta)
	
	velocity_component.do_character_move(self)

func apply_rotation() -> void:
	var normal_x = direction_input.x
	if normal_x < 0:
		normal_x = normal_x * -1
		
	var normal_y = direction_input.y
	if normal_y < 0:
		normal_y = normal_y * -1
		
	if normal_y > normal_x:
		if direction_input.y > 0:
			rotation_degrees = -90.0
		else:
			rotation_degrees = 90.0
	elif normal_y < normal_y:
		if direction_input.x > 0:
			rotation_degrees = 180.0
		else:
			rotation_degrees = 0.0
		
		
	var left_right_vector = Helpers.get_left_right_input_from_vector(direction_input)
	if left_right_vector == Vector2.LEFT:
		rotation_degrees = 0.0
	elif left_right_vector == Vector2.RIGHT:
		rotation_degrees = 180.0

func _ready() -> void:
	drill._on_drilling_aborted.connect(_on_drilling_aborted)
	drill._on_drilling_started.connect(_on_drilling_started)
	pass # Replace with function body.
	
func _on_drilling_started() -> void:
	move_to_center_component.set_must_move_to_center()

func _on_drilling_aborted() -> void:
	pass

func _on_down_ray_cast_2d_on_collision() -> void:
	velocity_component.apply_collision(Vector2.DOWN)
	pass # Replace with function body.

func _on_left_ray_cast_2d_on_collision() -> void:
	velocity_component.apply_collision(Vector2.LEFT)
	pass # Replace with function body.

func _on_right_ray_cast_2d_on_collision() -> void:
	velocity_component.apply_collision(Vector2.RIGHT)
	pass # Replace with function body.

func _on_up_ray_cast_2d_on_collision() -> void:
	velocity_component.apply_collision(Vector2.UP)
	pass # Replace with function body.
