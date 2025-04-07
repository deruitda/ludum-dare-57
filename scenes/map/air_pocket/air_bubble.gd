extends RigidBody2D
class_name AirBubble

func _physics_process(delta: float) -> void:
	if global_position.y < 0.0:
		queue_free()


func _on_body_entered(body: Node) -> void:
	
	pass # Replace with function body.
