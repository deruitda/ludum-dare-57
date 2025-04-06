extends Node2D

@onready var shop = %Shop

func _ready() -> void:
	SignalBus.close_shop.connect(_on_close_shop)
	SignalBus.open_shop.connect(_on_open_shop)
	SignalBus.player_exited_shop_area.connect(_on_player_exited_shop_area)

func _on_close_shop() -> void:
	shop.visible = false

func _on_open_shop() -> void:
	shop.visible = true

func _on_player_exited_shop_area() -> void:
	if shop.visible:
		shop.visible = false
