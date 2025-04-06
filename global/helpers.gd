extends Node
func get_left_right_input(direction_input: float) -> Vector2: 
	var left_right_input = Vector2.ZERO
	if direction_input > 0:
		left_right_input = Vector2.RIGHT
	elif direction_input < 0:
		left_right_input = Vector2.LEFT
	
	return left_right_input
func get_left_right_input_from_vector(direction_vector: Vector2) -> Vector2:
	
	var left_right_input = Vector2.ZERO
	if direction_vector.x > 0:
		left_right_input = Vector2.RIGHT
	elif direction_vector.x < 0:
		left_right_input = Vector2.LEFT
	
	return left_right_input
	
func round_to_dec(num: float, digit: int):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)
