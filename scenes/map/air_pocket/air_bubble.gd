extends RigidBody2D
class_name AirBubble
@onready var collision_velocity: float = 7.5
@onready var air_spout: AirSpout
func _physics_process(delta: float) -> void:
	if global_position.y < 0.0:
		air_spout._on_bubble_popped()
		queue_free()

func _on_body_entered(body: Node) -> void:
	if body is SubmarineBody:
		# Apply velocity to the bubble

		var direction = (global_position - body.global_position).normalized()  # Get the direction away from the player
		linear_velocity = direction * collision_velocity  # Apply the velocity
		# Call the custom function on the Player class
		body._on_bubble_collision(linear_velocity)  # This assumes `handle_bubble_collision` exists in the Player class


func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	
	if body is SubmarineBody:
		# Apply velocity to the bubble

		var direction = Vector2.UP# Get the direction away from the player
		var burst_velocity = direction * linear_velocity.length() * collision_velocity  # Apply the velocity
		print (linear_velocity)
		# Call the custom function on the Player class
		body._on_bubble_collision(burst_velocity)  # This assumes `handle_bubble_collision` exists in the Player class
