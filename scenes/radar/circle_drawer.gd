extends Node2D
class_name CircleDrawer


var current_rad: float = 0

func circle_draw(radius: float):
	current_rad = radius
	queue_redraw()

func _draw() -> void:
	draw_arc(self.position, current_rad, 0, TAU, 100, Color.LIGHT_GOLDENROD)
