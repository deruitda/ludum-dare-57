extends Node2D
class_name EdgeDetector

@onready var left_ray_cast_2d: RayCastCollider = $LeftRayCast2D
@onready var right_ray_cast_2d: RayCastCollider = $RightRayCast2D
@onready var up_ray_cast_2d: RayCastCollider = $UpRayCast2D
@onready var down_ray_cast_2d: RayCastCollider = $DownRayCast2D

func get_edge_directions() -> Array[Vector2]:
	var directions: Array[Vector2] = []
	if left_ray_cast_2d.is_colliding():
		directions.append(Vector2.LEFT)
	if right_ray_cast_2d.is_colliding():
		directions.append(Vector2.RIGHT)
	if up_ray_cast_2d.is_colliding():
		directions.append(Vector2.UP)
	if down_ray_cast_2d.is_colliding():
		directions.append(Vector2.DOWN)
	return directions
	
