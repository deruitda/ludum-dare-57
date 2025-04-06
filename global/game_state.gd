extends Node

@export var money_collected: int = 0
@export var max_cargo_weight: int = 10
var current_cargo_weight: int = 0
var current_cargo_value: int = 0

const TOTAL_DEPTH: float = 11800.0
const PIXEL_SIZE: int = 64

func _ready() -> void:
	SignalBus.add_money_collected.connect(_on_add_money_collected)
	SignalBus.add_cargo.connect(_on_add_cargo)
	SignalBus.sell_cargo.connect(_on_sell_cargo)
	
func _on_add_money_collected(money_paid: int) -> void:
	money_collected += money_paid
	SignalBus.money_collected_updated.emit()
		
func _on_add_cargo(tile_resource: ValuableTileResource) -> void:
	# If we are already at max capacity, do not add the valuable resource to the cargo
	if (current_cargo_weight >= max_cargo_weight):
		current_cargo_weight = max_cargo_weight
		SignalBus.cargo_at_max_capacity.emit()
		return
	
	# Add the weight of the new cargo, then check if we have hit capacity
	current_cargo_weight += tile_resource.weight
	current_cargo_value += tile_resource.price
	if (current_cargo_weight >= max_cargo_weight):
		current_cargo_weight = max_cargo_weight
		SignalBus.cargo_at_max_capacity.emit()
	
	SignalBus.cargo_updated.emit()
	

func _on_sell_cargo() -> void:
	SignalBus.add_money_collected.emit(current_cargo_value)
	current_cargo_value = 0
	current_cargo_weight = 0
	SignalBus.cargo_updated.emit()
