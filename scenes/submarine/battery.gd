extends Node
class_name Battery

@export var power_level: float = 100.0

func has_enough_power_for(potential_power_amount: float) -> bool:
	return power_level > potential_power_amount

func use_power(power_amount: float) -> bool:
	if not has_enough_power_for(power_amount):
		return false
	power_level = power_level - power_amount
	return true
