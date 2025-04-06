extends Node2D
class_name Checkpoint

@export var area_2ds: Array[Area2D]
@onready var has_entered: bool = false
@onready var spawn_location: Node2D = $SpawnLocation

func get_spawn_position() -> Vector2:
	return global_position
