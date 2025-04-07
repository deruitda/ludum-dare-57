extends Node

@onready var cargo_weight_label = %CargoWeightLabel
@onready var cargo_full_warning = %CargoFullWarning

func _ready() -> void:
	SignalBus.cargo_updated.connect(_on_cargo_updated)
	
	set_cargo_weight_text()

func _on_cargo_updated() -> void:
	set_cargo_weight_text()
	
	# Check if we are at cargo capacity
	if GameState.current_cargo_weight >= GameState.max_cargo_weight:
		# We are at capacity
		if !cargo_full_warning.visible:
			cargo_weight_label.visible = false
			cargo_full_warning.visible = true
			
	else:
		# We are below capacity
		if cargo_full_warning.visible:
			cargo_weight_label.visible = true
			cargo_full_warning.visible = false
		
		

func set_cargo_weight_text() -> void:
	cargo_weight_label.text = str(GameState.current_cargo_weight) + " / " + str(GameState.max_cargo_weight)
