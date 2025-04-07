extends Node

@onready var ship_animation_sprite = %ShipAnimatedSprite2D

func _ready():
	var canvas_size = ship_animation_sprite.get_parent().get_size()
	var ship_width_px = 600
	var ship_height_px = 384
	
	var scale_x = canvas_size.x / ship_width_px
	var scale_y = canvas_size.y / ship_height_px

	# Apply the scaling
	ship_animation_sprite.scale.x = scale_x
	ship_animation_sprite.scale.y = scale_y


func _on_start_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
