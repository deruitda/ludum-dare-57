extends Node

var ping_scene = preload("res://scenes/radar/ping.tscn")

func _ready() -> void:
	SignalBus.resource_pinged.connect(spawn_ping)
	
func spawn_ping(coords: Vector2, tile_resource: ValuableTileResource):
	var instance = ping_scene.instantiate() as Ping
	instance.light_color = tile_resource.ping_color
	instance.target_position = coords
	instance.special = tile_resource.is_special
	get_tree().root.add_child(instance)
