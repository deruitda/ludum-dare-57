extends Node
class_name VelocityComponent
@export var acceleration = 1000.0
@export var deceleration =  1000.0
@export var max_speed: float = 1000.0

@onready var velocity: Vector2
@onready var current_rotation: float = 0.0
@onready var drag_resistance: float = 500.0
func set_current_rotation(_rotation: float) -> void:
	current_rotation = _rotation

func is_moving() -> bool:
	return velocity.x != 0 || velocity.y != 0

func set_velocity(_velocity: Vector2) -> void:
	velocity = _velocity

func apply_move(direction: Vector2, delta: float) -> void:
	var acceleration_metric = acceleration
	var deceleration_metric = deceleration

	# Handle X-axis
	if sign(direction.x) != sign(velocity.x) and velocity.x != 0:
		# If the direction is opposite to the current velocity, apply deceleration
		velocity.x = clamp(velocity.x + (direction.x * deceleration_metric * delta), -max_speed, max_speed)
	else:
		# Otherwise, apply regular acceleration
		velocity.x = clamp(velocity.x + (direction.x * acceleration_metric * delta), -max_speed, max_speed)

	# Handle Y-axis
	if sign(direction.y) != sign(velocity.y) and velocity.y != 0:
		# Apply deceleration for opposite direction
		velocity.y = clamp(velocity.y + (direction.y * deceleration_metric * delta), -max_speed, max_speed)
	else:
		# Otherwise, apply regular acceleration
		velocity.y = clamp(velocity.y + (direction.y * acceleration_metric * delta), -max_speed, max_speed)
	
	if direction.x == 0.0:
		velocity.x = move_toward(velocity.x, 0, drag_resistance * delta)
	
	if direction.y == 0.0:
		velocity.y = move_toward(velocity.y, 0, drag_resistance * delta)

func set_collision_direction(_direction: Vector2) -> void:
	if _direction.x != 0.0:
		if _direction.x > 0.0 and velocity.x > 0.0 or _direction.x < 0.0 and velocity.x < 0.0:
			velocity.x = 0.0
	if _direction.y != 0.0:
		if _direction.y > 0.0 and velocity.y > 0.0 or _direction.y < 0.0 and velocity.y < 0.0:
			velocity.y = 0.0

func apply_gravity(delta: float):
	velocity.y += (9.8 * GameState.PIXEL_SIZE * delta)

func do_character_move(character_body: CharacterBody2D):
	character_body.velocity = velocity
	character_body.move_and_slide()
	
func add_burst_velocity(linear_velocity: Vector2) -> void:
	velocity += linear_velocity
