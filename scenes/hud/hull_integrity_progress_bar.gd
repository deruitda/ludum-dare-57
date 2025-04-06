extends ProgressBar
@onready var STARTING_COLOR: Color = Color.RED
@export var DECREMENT_FLASH_COLOR: Color = Color.DARK_RED
@export var INCREMENT_FLASH_COLOR: Color = Color.GREEN
var tween: Tween = null

func _ready() -> void:
	SignalBus.hull_health_updated.connect(_on_hull_health_updated)
	modulate = STARTING_COLOR

func _on_hull_health_updated(hull: Hull):
	var new_value = hull.get_hull_health_percentage()
	if new_value < value:
		flash_progress_bar(DECREMENT_FLASH_COLOR)
	elif new_value > value:
		flash_progress_bar(INCREMENT_FLASH_COLOR)
	
	value = new_value * 100.0
	
func flash_progress_bar(_flash_color: Color):
	if tween:
		return
	# Cancel any existing tweens
	
	modulate = _flash_color
# Create a fresh tween each time to avoid invalid reference
	var tween := create_tween()
	tween.tween_property(self, "modulate", STARTING_COLOR, 0.2)
	tween.connect("finished", tween_done)

func tween_done():
	tween = null
