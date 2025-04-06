extends Node

@export var money_collected: int = 100
@export var max_cargo_weight: int = 10
var current_cargo_weight: int = 0
var current_cargo_value: int = 0
@export var is_shop_opened: bool = false
var is_player_in_shop_area: bool = false

const TOTAL_DEPTH: float = 11800.0
const PIXEL_SIZE: int = 64

func _ready() -> void:
	SignalBus.add_money_collected.connect(_on_add_money_collected)
	SignalBus.add_cargo.connect(_on_add_cargo)
	SignalBus.sell_cargo.connect(_on_sell_cargo)
	SignalBus.purchase_upgrade.connect(_on_purchase_upgrade)
	SignalBus.close_shop.connect(_on_close_shop)
	SignalBus.open_shop.connect(_on_open_shop)
	SignalBus.player_entered_shop_area.connect(_on_player_entered_shop_area)
	SignalBus.player_exited_shop_area.connect(_on_player_exited_shop_area)
	
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

func _on_purchase_upgrade(shop_item_resource: ShopItemResource) -> void:
	assert(money_collected >= shop_item_resource.price)
	money_collected -= shop_item_resource.price
	# If the purchase is an "unlockable" item, unlock it
	if shop_item_resource.item_resource and shop_item_resource.item_resource.is_unlocked == false:
		shop_item_resource.item_resource.is_unlocked = true
	SignalBus.money_collected_updated.emit()
	SignalBus.purchase_completed.emit(shop_item_resource)

func _on_close_shop() -> void:
	is_shop_opened = false

func _on_open_shop() -> void:
	if is_player_in_shop_area:
		is_shop_opened = true

func _on_player_entered_shop_area() -> void:
	is_player_in_shop_area = true

func _on_player_exited_shop_area() -> void:
	is_player_in_shop_area = false
	if is_shop_opened:
		is_shop_opened = false
