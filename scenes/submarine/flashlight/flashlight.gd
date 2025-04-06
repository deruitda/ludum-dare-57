extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var light: PointLight2D = $PointLight2D

var is_on = false

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_F and !animated_sprite.is_playing():
			toggle_flashlight()

func toggle_flashlight():
	if !light.enabled:
		animated_sprite.play("open")
	else:
		animated_sprite.play("close")
		
	


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "open":
		light.enabled = true


func _on_animated_sprite_2d_animation_changed() -> void:
	if animated_sprite.animation == "close":
		light.enabled = false
