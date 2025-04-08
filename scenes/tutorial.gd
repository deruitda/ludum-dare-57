extends Node2D

@export var radar: ShopItemResource
@export var flashlight: ShopItemResource

func _ready() -> void:
	SignalBus.purchase_completed.emit(radar)
	SignalBus.purchase_completed.emit(flashlight)


func _on_start_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/starting_scene.tscn")
