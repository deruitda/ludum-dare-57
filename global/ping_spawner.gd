extends Node

var ping_scene = preload("res://scenes/radar/ping.tscn")

func _ready() -> void:
	SignalBus.resource_pinged.connect(spawn_ping)
	
func spawn_ping(coords: Vector2, tile_resource: TileResource):
	var instance = ping_scene.instantiate() as Ping
	instance.global_position = coords
	get_tree().root.add_child(instance)
