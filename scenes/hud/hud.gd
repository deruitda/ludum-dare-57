extends Node

@onready var collected_money_rich_text = %CollectedMoneyRichText
@onready var add_material_button = %AddMaterialButton

func _ready() -> void:
	SignalBus.money_collected_updated.connect(_on_signal_money_collected_updated)
	SignalBus.cargo_updated.connect(_on_signal_cargo_updated)

# Temporary game state updates when clicking buttons for testing purposesd

# Testing Cargo / Materials
func _on_add_material_button_pressed() -> void:
	SignalBus.add_cargo.emit()

func _on_signal_cargo_updated() -> void:
	add_material_button.set_text("Add Material " + str(GameState.current_cargo_weight))

# Testing Money
func _on_get_paid_pressed() -> void:
	SignalBus.add_money_collected.emit(1)

func _on_signal_money_collected_updated() -> void:
	collected_money_rich_text.set_text("$" + str(GameState.money_collected))

func _on_sell_cargo_button_pressed() -> void:
	SignalBus.sell_cargo.emit()
