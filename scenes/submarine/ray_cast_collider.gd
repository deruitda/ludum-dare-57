extends RayCast2D
class_name RayCastCollider

signal on_collision
signal on_collision_exit

@onready var _is_colliding: bool = false

func _physics_process(delta: float) -> void:
	if is_colliding() and _is_colliding == false:
		on_collision.emit()
		_is_colliding = true
	elif is_colliding() == false and _is_colliding == true:
		on_collision_exit.emit()
		_is_colliding = false
func get_collider_direction() -> Vector2:
	# Default direction (90 degrees to the left, which is -90 degrees)
	var default_direction = Vector2(0.0, -1.0)  # Upward direction in the local coordinate system
	
	# Rotate the direction by the given rotation
	var _direction = default_direction.rotated(global_rotation)

	# Round the vector components to remove small precision errors
	_direction.x = Helpers.round_to_dec(_direction.x, 3)  # Round x to 3 decimal places (or adjust as needed)
	_direction.y = Helpers.round_to_dec(_direction.y, 3)  # Round x to 3 decimal places (or adjust as needed)

	# Return the resulting direction
	return _direction
