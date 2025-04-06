extends ProgressBar
class_name DepthProgressBar

@onready var sub_progress_icon: TextureRect = $SubProgressIcon

func _ready() -> void:
	SignalBus.set_current_depth.connect(_update_current_depth)
	modulate = get_health_color()
	

func _update_current_depth(current_depth: float) -> void:
	var val = current_depth / (GameState.TOTAL_DEPTH / 64)
	sub_progress_icon.anchor_bottom = val
	sub_progress_icon.anchor_top = val
	value = 100 - val
	
	modulate = get_health_color()

func get_health_color() -> Color:
	# Clamp to 0.0 - 1.0
	var percent = clamp(value, 0.0, 1.0)

	var red = Color(1, 0, 0)     # Full red
	var green = Color(0, 1, 0)   # Full green

	# Lerp from red to green (low health = red, high health = green)
	return red.lerp(green, percent)
