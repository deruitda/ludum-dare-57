extends Node

@onready var collected_money_rich_text = %CollectedMoneyRichText
@onready var open_store_button = %OpenStoreButton
@onready var toggle_flashlight_button: TextureButton = %ToggleFlashlightButton

func _ready() -> void:
	SignalBus.money_collected_updated.connect(_on_signal_money_collected_updated)
	SignalBus.player_entered_shop_area.connect(_on_player_entered_shop_area)
	SignalBus.player_exited_shop_area.connect(_on_player_exited_shop_area)
	SignalBus.purchase_completed.connect(_on_purchase_complete)
	set_collected_money_rich_text()
	
func _on_purchase_complete(shop_item: ShopItemResource):
	if shop_item.item_resource is FlashlightResource:
		toggle_flashlight_button.visible = true
func _on_signal_money_collected_updated() -> void:
	set_collected_money_rich_text()

func _on_open_store_button_pressed() -> void:
	if GameState.is_player_in_shop_area:
		SignalBus.open_shop.emit()

func _on_player_entered_shop_area() -> void:
	if !open_store_button.visible:
		open_store_button.visible = true

func _on_player_exited_shop_area() -> void:
	if open_store_button.visible:
		open_store_button.visible = false

func set_collected_money_rich_text():
	collected_money_rich_text.set_text("$" + str(GameState.money_collected))

func _on_toggle_flashlight_button_pressed() -> void:
	SignalBus.toggle_flashlight.emit()


func _on_activate_radar_button_pressed() -> void:
	SignalBus.ping_sonar.emit()
