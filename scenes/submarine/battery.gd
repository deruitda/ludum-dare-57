extends Node
class_name Battery

@export var current_power_level: float = 100.0
@export var max_power_level: float = 100.0

func _ready() -> void:
	SignalBus.battery_updated.emit(self)

func has_enough_power_for(potential_power_amount: float) -> bool:
	return current_power_level > potential_power_amount

func get_percentage_of_power_left() -> float:
	return current_power_level / max_power_level

func consume_power(power_amount: float) -> void:
	current_power_level = max(current_power_level - power_amount, 0.0)
	SignalBus.battery_updated.emit(self)
	if current_power_level == 0.0:
		SignalBus.submarine_lost_power.emit()
