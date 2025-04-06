extends ProgressBar
@onready var STARTING_COLOR: Color = Color.GOLD
@export var FLASH_COLOR: Color = Color.DARK_RED
@export var battery_warning_threshold_percentage: float = 0.25

var tween: Tween = null
@onready var flash_timer: Timer = $FlashTimer

func _ready() -> void:
	SignalBus.battery_updated.connect(_on_battery_updated)
	modulate = STARTING_COLOR

func _on_battery_updated(battery: Battery):
	value = battery.get_percentage_of_power_left()
	if value < battery_warning_threshold_percentage:
		flash_progress_bar()
		if flash_timer.paused:
			flash_timer.start()
			
	elif not flash_timer.paused:
		flash_timer.stop()
	
func flash_progress_bar():
	if tween:
		return
	# Cancel any existing tweens
	
	modulate = FLASH_COLOR
# Create a fresh tween each time to avoid invalid reference
	var tween := create_tween()
	tween.tween_property(self, "modulate", STARTING_COLOR, 0.2)
	tween.connect("finished", tween_done)

func tween_done():
	tween = null


func _on_flash_timer_timeout() -> void:
	flash_progress_bar()
	pass # Replace with function body.
