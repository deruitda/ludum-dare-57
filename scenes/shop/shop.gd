extends CanvasLayer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _on_close_shop_button_pressed() -> void:
	SignalBus.close_shop.emit()


func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE and GameState.is_shop_opened:
			SignalBus.close_shop.emit()
		
		if event.keycode == KEY_E and GameState.is_player_in_shop_area and !GameState.is_shop_opened:
			SignalBus.open_shop.emit()
