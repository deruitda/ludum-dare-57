extends Node2D
class_name DrillPosition

const DRILL_POSITION_LEFT: Vector2 = Vector2(-32.0, 0)
const DRILL_ROTATION_LEFT: float = -90.0
const DRILL_POSITION_RIGHT: Vector2 = Vector2(32.0, 0)
const DRILL_ROTATION_RIGHT: float = 90.0


const DRILL_POSITION_UP: Vector2 = Vector2(0, 32.0)
const DRILL_ROTATION_UP: float = 0.0
const DRILL_POSITION_DOWN: Vector2 = Vector2(0, -32.0)
const DRILL_ROTATION_DOWN: float = 180.0

@export var drill: Drill

func point_left() -> void:
	rotation = DRILL_ROTATION_LEFT
	position = DRILL_POSITION_LEFT
	
func point_right() -> void: 
	rotation = DRILL_ROTATION_RIGHT
	position = DRILL_POSITION_RIGHT
