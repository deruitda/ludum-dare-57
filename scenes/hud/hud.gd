extends Node

@onready var collected_money_rich_text = %CollectedMoneyRichText

func _ready() -> void:
	SignalBus.money_collected_updated.connect(_on_signal_money_collected_updated)

func _on_signal_money_collected_updated() -> void:
	collected_money_rich_text.set_text("$" + str(GameState.money_collected))

func _on_activate_radar_button_pressed() -> void:
	pass # TODO: Ping radar when clicking this button, just like clicking R

func _on_open_store_button_pressed() -> void:
	SignalBus.open_shop.emit()
