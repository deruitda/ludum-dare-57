extends Button
class_name ShopButton

@onready var price_label = %PriceLabel

@export var shop_item_resource: ShopItemResource
var battery: Battery
var hull: Hull
var full_integrity_string = "Full Integrity"
var full_charge_string = "Full Charge"

func _ready():
	SignalBus.money_collected_updated.connect(_on_money_collected_updated)
	SignalBus.purchase_completed.connect(_on_purchase_completed)
	SignalBus.hull_health_updated.connect(_on_hull_health_updated)
	SignalBus.battery_updated.connect(_on_battery_updated)
	
	set_price_label_text()	
	set_price_label_color()
	set_button_disabled_conditionally()

func _on_pressed() -> void:
	# If able to purchase the item, signal the purchase
	if !is_player_unable_to_purchase_item():
		SignalBus.purchase_upgrade.emit(shop_item_resource)

func _on_money_collected_updated() -> void:
	set_price_label_color()
	set_button_disabled_conditionally()

func _on_purchase_completed(purchased_shop_item_resource: ShopItemResource):
	set_button_disabled_conditionally()
	if !purchased_shop_item_resource.is_infinitely_purchaseable and purchased_shop_item_resource == shop_item_resource:
		price_label.text = "Purchased"

# Enable or disable the Repair Hull button based on the hull health
func _on_hull_health_updated(_hull: Hull):
	hull = _hull
	set_button_disabled_conditionally()

func _on_battery_updated(_battery: Battery):
	battery = _battery
	set_button_disabled_conditionally()

# Return true if the item can only be purchased once and is already unlocked
func has_shop_item_already_been_purchased() -> bool:
	return shop_item_resource \
	and !shop_item_resource.is_infinitely_purchaseable \
	and shop_item_resource.item_resource \
	and shop_item_resource.item_resource.is_unlocked == true

# Return true if the item has not been purchased yet and the player can't afford it
func is_player_unable_to_afford_item() -> bool:
	return shop_item_resource and shop_item_resource.price > GameState.money_collected

# Player is not able to purchase the button if any of the conditions are true:
#   1. There is no Shop Item Resource set for the Shop Button
#   2. The Shop Item is locked behind another Shop Resource
#   3. The Shop Item has already been purchased
#   4. The player cannot afford the Shop Item 
func is_player_unable_to_purchase_item() -> bool:
	if shop_item_resource.item_resource is RepairHullResource:
		# If hull is new or fully repaired, button is disabled
		if (hull == null or hull.health >= hull.hull_resource.max_health):
			if price_label.text != full_integrity_string:
				price_label.text = full_integrity_string
			return true
			
		if price_label.text == full_integrity_string:
			set_price_label_text()
		return is_player_unable_to_afford_item()

	var is_shop_item_locked = shop_item_resource.unlocked_by_item_resource and shop_item_resource.unlocked_by_item_resource.is_unlocked != true

	return shop_item_resource == null \
	or is_shop_item_locked \
	or has_shop_item_already_been_purchased() \
	or is_player_unable_to_afford_item()

# Button is disabled if the player is not able to purchase the item
func set_button_disabled_conditionally() -> void:
	disabled = is_player_unable_to_purchase_item()

func set_price_label_text() -> void:
	var new_price_text = "$" + str(shop_item_resource.price)
	if shop_item_resource and new_price_text != price_label.text:
		price_label.text = new_price_text

func set_price_label_color() -> void:
	# Set price color to red if the player cannot afford the item AND it hasn't been purchased yet
	if !has_shop_item_already_been_purchased() and is_player_unable_to_afford_item():
		price_label.set("theme_override_colors/font_color", "#ff0000")
	# Otherwise, set the color to green
	else:
		price_label.set("theme_override_colors/font_color", "#00ff00")
