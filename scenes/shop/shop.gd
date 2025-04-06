extends CanvasLayer


func _on_sell_cargo_button_pressed() -> void:
	SignalBus.sell_cargo.emit()


func _on_close_shop_button_pressed() -> void:
	SignalBus.close_shop.emit()


func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE and GameState.is_shop_opened:
			SignalBus.close_shop.emit()
		
		if event.keycode == KEY_E and !GameState.is_shop_opened:
			SignalBus.open_shop.emit()
