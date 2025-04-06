extends ProgressBar
@onready var STARTING_COLOR: Color = Color.GOLD
@export var FLASH_COLOR: Color = Color.DARK_RED
@export var battery_warning_threshold_percentage: float = .25

var tween: Tween = null

func _ready() -> void:
	SignalBus.battery_updated.connect(_on_battery_updated)
	modulate = STARTING_COLOR

func _process(delta: float) -> void:
	if value < battery_warning_threshold_percentage and not tween:
		flash_progress_bar()
			
	

func _on_battery_updated(battery: Battery):
	value = battery.get_percentage_of_power_left()
	
func flash_progress_bar():
	if tween:
		return
	# Cancel any existing tweens
	
	modulate = FLASH_COLOR
# Create a fresh tween each time to avoid invalid reference
	tween = create_tween()
	tween.tween_property(self, "modulate", STARTING_COLOR, .9)
	tween.connect("finished", tween_done)

func tween_done():
	tween = null
