extends Node
class_name VelocityComponent
@export var acceleration = 1000.0
@export var max_speed: float = 1000.0

@onready var velocity: Vector2
@onready var current_rotation: float = 0.0
@onready var drag_resistance: float = 800.0
func set_rotation(rotation: float) -> void:
	current_rotation = rotation

func apply_move(direction: Vector2, delta: float) -> void:
	var acceleration_metric = acceleration
	
	if direction.x == 0.0:
		velocity.x = move_toward(velocity.x, 0, drag_resistance * delta)
	else:
		velocity.x = clamp(velocity.x + (direction.x * acceleration_metric * delta), -max_speed, max_speed)
	
	if direction.y == 0.0:
		velocity.y = move_toward(velocity.y, 0, drag_resistance * delta)
	else:
		velocity.y = clamp(velocity.y + (direction.y * acceleration_metric * delta), -max_speed, max_speed)




	

func do_character_move(character_body: CharacterBody2D):
	
	character_body.velocity = velocity
	character_body.move_and_slide()

func apply_collision(collision_direction: Vector2):
	if collision_direction.x > 0 and velocity.x > 0:
		velocity.x = 0
	elif collision_direction.x < 0 and velocity.x < 0:
		velocity.x = 0
		
	if collision_direction.y > 0 and velocity.y > 0:
		velocity.y = 0
	elif collision_direction.y < 0 and velocity.y < 0:
		velocity.y = 0
