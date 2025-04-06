extends Node2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		SignalBus.player_entered_shop_area.emit()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		SignalBus.player_exited_shop_area.emit()
