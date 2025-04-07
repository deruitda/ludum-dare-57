extends Node2D

@onready var shop = %Shop
@onready var total_play_time: float = 0.0
var is_playing_game: bool = true

func _ready() -> void:
	SignalBus.close_shop.connect(_on_close_shop)
	SignalBus.open_shop.connect(_on_open_shop)
	SignalBus.player_exited_shop_area.connect(_on_player_exited_shop_area)

func _process(delta: float) -> void:
	if is_playing_game:
		total_play_time += delta

func _on_close_shop() -> void:
	shop.visible = false

func _on_open_shop() -> void:
	shop.visible = true

func _on_player_exited_shop_area() -> void:
	if shop.visible:
		shop.visible = false

func _on_winning_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		is_playing_game = false
		SignalBus.player_has_won.emit(total_play_time)
		get_tree().change_scene_to_file("res://scenes/winning_scene.tscn")
