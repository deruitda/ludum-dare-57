extends CharacterBody2D
@export var speed = 400

func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * speed
	print("Input" + str(input_direction))

func _physics_process(delta):
	get_input()
	move_and_slide()

func _ready() -> void:
	pass # Replace with function body.
	
