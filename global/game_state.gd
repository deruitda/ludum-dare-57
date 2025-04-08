extends Node

@export var INITIAL_MONEY_COLLECTED = 0
@export var INITIAL_MAX_CARGO_WEIGHT = 10
var INITIAL_CARGO_WEIGHT = 0
var INITIAL_CARGO_VALUE = 0

## The total money ever collected by the player, used for final game stats
var total_money_collected = INITIAL_MONEY_COLLECTED
## The current amount of money the player has available to spend
var money_collected: int = INITIAL_MONEY_COLLECTED
var max_cargo_weight: int = INITIAL_MAX_CARGO_WEIGHT
var current_cargo_weight: int = INITIAL_CARGO_WEIGHT
var current_cargo_value: int = INITIAL_CARGO_VALUE

@export var TOTAL_ALLOWED_BUBBLES:int = 1000
@onready var total_bubbles: int = 0

@export var is_shop_opened: bool = false
var is_player_in_shop_area: bool = false

var depth: float = 0.0

const TOTAL_DEPTH: float = 11800.0
const PIXEL_SIZE: int = 64

# Winning information
var total_play_time_in_seconds = 0

func _ready() -> void:
	SignalBus.new_game.connect(_on_new_game)
	SignalBus.add_cargo.connect(_on_add_cargo)
	SignalBus.purchase_upgrade.connect(_on_purchase_upgrade)
	SignalBus.close_shop.connect(_on_close_shop)
	SignalBus.open_shop.connect(_on_open_shop)
	SignalBus.player_entered_shop_area.connect(_on_player_entered_shop_area)
	SignalBus.player_exited_shop_area.connect(_on_player_exited_shop_area)
	SignalBus.hull_destroyed.connect(die)
	SignalBus.submarine_lost_power.connect(die)
	SignalBus.player_has_won.connect(_on_player_has_won)

func _on_new_game() -> void:
	current_cargo_value = INITIAL_CARGO_VALUE
	current_cargo_weight = INITIAL_CARGO_WEIGHT
	max_cargo_weight = INITIAL_MAX_CARGO_WEIGHT
	money_collected = INITIAL_MONEY_COLLECTED
	SignalBus.cargo_updated.emit()
	SignalBus.money_collected_updated.emit()

	
func die():
	current_cargo_value = 0
	current_cargo_weight = 0
	SignalBus.cargo_updated.emit()

func update_depth(new_depth: float):
	depth = new_depth
	
func add_money_collected(money_paid: int) -> void:
	total_money_collected += money_paid
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
	

func sell_cargo() -> void:
	add_money_collected(current_cargo_value)
	current_cargo_value = 0
	current_cargo_weight = 0
	SignalBus.cargo_updated.emit()

func _on_purchase_upgrade(shop_item_resource: ShopItemResource) -> void:
	assert(shop_item_resource.item_resource != null)
	# If an item in the shop somehow allows you to purchase an item you can't afford, skip purchase
	if money_collected < shop_item_resource.price:
		pass
	
	money_collected -= shop_item_resource.price
	
	if shop_item_resource.item_resource is CargoCapacityResource and shop_item_resource.item_resource.new_cargo_capacity is int:
		max_cargo_weight = shop_item_resource.item_resource.new_cargo_capacity
		SignalBus.cargo_updated.emit()
	
	# If the purchase is an "unlockable" item, unlock it
	if shop_item_resource.item_resource is UpgradeResource and !shop_item_resource.item_resource.is_unlocked:
		shop_item_resource.item_resource.is_unlocked = true
	
	
	
	SignalBus.money_collected_updated.emit()
	SignalBus.purchase_completed.emit(shop_item_resource)

func _on_close_shop() -> void:
	is_shop_opened = false

func _on_open_shop() -> void:
	if is_player_in_shop_area:
		sell_cargo()
		SignalBus.sell_cargo.emit()
		SignalBus.recharge_battery.emit()
		is_shop_opened = true

func _on_player_entered_shop_area() -> void:
	is_player_in_shop_area = true

func _on_player_exited_shop_area() -> void:
	is_player_in_shop_area = false
	if is_shop_opened:
		is_shop_opened = false

func _on_player_has_won(_total_play_time: float) -> void:
	total_play_time_in_seconds = _total_play_time
