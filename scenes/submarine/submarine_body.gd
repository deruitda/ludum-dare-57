extends CharacterBody2D
@export var speed = 400
@export var drill: DrillPosition
@export var velocity_component: VelocityComponent

@onready var direction_input: Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	direction_input = Input.get_vector("move_left", "move_right", "move_up", "move_down")

func _physics_process(delta: float):
	apply_rotation()
	
	velocity_component.apply_move(direction_input, delta)
	velocity_component.do_character_move(self)

func apply_rotation() -> void:
	var left_right_vector = Helpers.get_left_right_input_from_vector(direction_input)
	if left_right_vector == Vector2.LEFT:
		rotation_degrees = 0.0
	elif left_right_vector == Vector2.RIGHT:
		rotation_degrees = 180.0

func _ready() -> void:
	pass # Replace with function body.
	
