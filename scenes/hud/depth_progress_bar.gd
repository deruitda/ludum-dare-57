extends ProgressBar
class_name DepthProgressBar

@export var HEALTHY_COLOR: Color = Color.GREEN
@export var UNHEALTHY_COLOR: Color = Color.RED

@onready var sub_progress_icon: TextureRect = $SubProgressIcon

func _ready() -> void:
	SignalBus.set_current_depth.connect(_update_current_depth)
	SignalBus.set_normalized_depth_percentage.connect(_update_normalized_depth_percentage_color)
	modulate = get_health_color(0.0)
	

func _update_current_depth(current_depth: float) -> void:
	var val = current_depth / (GameState.TOTAL_DEPTH / GameState.PIXEL_SIZE)
	sub_progress_icon.anchor_bottom = val
	sub_progress_icon.anchor_top = val
	value = 100 - (val * 100)
	
func _update_normalized_depth_percentage_color(normalized_depth_percentage: float) -> void:
	modulate = get_health_color(normalized_depth_percentage)
	
	
func get_health_color(percentage: float) -> Color:
	print(percentage)
	# Lerp from red to green (low health = red, high health = green)
	return HEALTHY_COLOR.lerp(UNHEALTHY_COLOR, percentage)
