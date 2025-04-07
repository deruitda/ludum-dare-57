extends RigidBody2D
class_name AirBubble
@onready var collision_velocity: float = 7.5
@onready var air_spout: AirSpout

@onready var frozen_self_destruct_time = 1.0 # how long after being Vector2.ZERO before self popping
@onready var current_self_destruct_time = 0.0

@onready var total_number_of_collisions_with_player_allowed: int = 3
@onready var number_of_collisions_with_player: int = 0

func _ready() -> void:
	frozen_self_destruct_time = randf_range(0.5, 2.0)
func _process(delta: float):
	if linear_velocity.length() <= 0.1:
		current_self_destruct_time += delta
	else:
		current_self_destruct_time = 0.0
	if current_self_destruct_time > frozen_self_destruct_time:
		pop_self()
		
#
func _physics_process(delta: float) -> void:
	if global_position.y < 0.0:
		pop_self()
	
func pop_self() -> void:
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
		# Call the custom function on the Player class
		body._on_bubble_collision(burst_velocity)  # This assumes `handle_bubble_collision` exists in the Player class
		number_of_collisions_with_player += 1
		if number_of_collisions_with_player >= total_number_of_collisions_with_player_allowed:
			pop_self()
