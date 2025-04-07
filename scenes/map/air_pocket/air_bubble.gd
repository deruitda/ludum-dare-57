extends RigidBody2D
class_name AirBubble

func _physics_process(delta: float) -> void:
	if global_position.y < 0.0:
		queue_free()
