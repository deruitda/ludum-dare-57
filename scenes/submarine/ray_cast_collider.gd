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
