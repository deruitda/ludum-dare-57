extends ProgressBar
class_name DepthProgressBar

@onready var MAX_DEPTH: int
@onready var sub_progress_icon: TextureRect = $SubProgressIcon

func _ready() -> void:
	MAX_DEPTH = 150000 / 64
	SignalBus.set_current_depth.connect(_update_current_depth)

func _update_current_depth(current_depth: float) -> void:
	var val = current_depth / MAX_DEPTH
	sub_progress_icon.anchor_bottom = val
	sub_progress_icon.anchor_top = val
	value = 100 - val
