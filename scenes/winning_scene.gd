extends CanvasLayer


func _on_play_again_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	SignalBus.new_game.emit()
