extends ProgressBar
class_name DepthProgressBar

@export var HEALTHY_COLOR: Color = Color.GREEN
@export var UNHEALTHY_COLOR: Color = Color.RED

@onready var sub_progress_icon: TextureRect = $SubProgressIcon

func _ready() -> void:
	SignalBus.set_current_depth.connect(_update_current_depth)
	modulate = get_health_color()
	

func _update_current_depth(current_depth: float) -> void:
	var val = current_depth / (GameState.TOTAL_DEPTH / GameState.PIXEL_SIZE)
	sub_progress_icon.anchor_bottom = val
	sub_progress_icon.anchor_top = val
	value = 100 - (val * 100)
	
	modulate = get_health_color()

func get_health_color() -> Color:
	var percent = value / 100.0


	# Lerp from red to green (low health = red, high health = green)
	return UNHEALTHY_COLOR.lerp(HEALTHY_COLOR, percent)
