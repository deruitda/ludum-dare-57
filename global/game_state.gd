extends Node

@export var money_collected: int = 0
@export var max_cargo_weight: int = 10
var current_cargo_weight: int = 0

const TOTAL_DEPTH: float = 11800.0
const PIXEL_SIZE: int = 64

func _ready() -> void:
	SignalBus.add_money_collected.connect(_on_add_money_collected)
	SignalBus.add_cargo.connect(_on_add_cargo)
	SignalBus.sell_cargo.connect(_on_sell_cargo)
	
func _on_add_money_collected(money_paid: int) -> void:
	money_collected += money_paid
	SignalBus.money_collected_updated.emit()
	
func _on_add_cargo() -> void:
	current_cargo_weight += 1
	
	if (current_cargo_weight >= max_cargo_weight):
		current_cargo_weight = max_cargo_weight
		SignalBus.cargo_at_max_capacity.emit()
	
	SignalBus.cargo_updated.emit()

func _on_sell_cargo() -> void:
	SignalBus.add_money_collected.emit(current_cargo_weight)
	current_cargo_weight = 0
	SignalBus.cargo_updated.emit()
