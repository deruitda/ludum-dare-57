extends ProgressBar
@onready var STARTING_COLOR: Color = Color.RED
@export var FLASH_COLOR: Color = Color.DARK_RED
var tween: Tween = null

func _ready() -> void:
	SignalBus.player_health_changed.connect(_on_player_health_changed)
	modulate = STARTING_COLOR

func _on_player_health_changed(health: float):
	value = health
	flash_progress_bar()
	
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
