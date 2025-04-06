extends ProgressBar
class_name DepthProgressBar

@onready var sub_progress_icon: TextureRect = $SubProgressIcon

func _ready() -> void:
	SignalBus.set_current_depth.connect(_update_current_depth)
	modulate = get_health_color(1.0)
	

func _update_current_depth(current_depth: float) -> void:
	var val = current_depth / (GameState.TOTAL_DEPTH / GameState.PIXEL_SIZE)
	sub_progress_icon.anchor_bottom = val
	sub_progress_icon.anchor_top = val
	
	modulate = get_health_color(val)

func get_health_color(percentage: float) -> Color:

	var red = Color.RED    # Full red
	var green = Color.GREEN # Full greens

	# Lerp from red to green (low health = red, high health = green)
	return green.lerp(red, percentage)
