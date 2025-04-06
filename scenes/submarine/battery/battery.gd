extends Node
class_name Battery

@export var current_power_level: float
@export var battery_resource: BatteryResource

func _ready() -> void:
	fully_charge_battery()
	SignalBus.battery_updated.emit(self)
	SignalBus.purchase_completed.connect(_shop_item_purchased)

func _shop_item_purchased(shop_item_resource: ShopItemResource):
	if shop_item_resource.item_resource is BatteryResource:
		upgrade_battery(shop_item_resource.item_resource)

func has_enough_power_for(potential_power_amount: float) -> bool:
	return current_power_level > potential_power_amount

func get_percentage_of_power_left() -> float:
	return current_power_level / battery_resource.max_power_level

func fully_charge_battery() -> void:
	_set_current_power_level(battery_resource.max_power_level)

func _set_current_power_level(power_amount: float) -> void:
	current_power_level = power_amount
	SignalBus.battery_updated.emit(self)
	if current_power_level == 0.0:
		SignalBus.submarine_lost_power.emit()

func upgrade_battery(_battery_resource: BatteryResource):
	battery_resource = _battery_resource
	fully_charge_battery()

func consume_power(power_amount: float) -> void:
	power_amount = max(current_power_level - power_amount, 0.0)
	_set_current_power_level(power_amount)
