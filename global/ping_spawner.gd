extends Node

var ping_scene = preload("res://scenes/radar/ping.tscn")

func _ready() -> void:
	SignalBus.resource_pinged.connect(spawn_ping)
	
func spawn_ping(coords: Vector2, tile_resource: TileResource):
	var instance = ping_scene.instantiate() as Ping
	
	if tile_resource.name == "valuable_1":
		instance.light_color = Color.SEA_GREEN
	
	if tile_resource.name == "valuable_2":
		instance.light_color = Color.DODGER_BLUE
	
	if tile_resource.name == "valuable_3":
		instance.light_color = Color.GOLD
	
	if tile_resource.name == "valuable_4" or tile_resource.name == "valuable_5" or tile_resource.name == "valuable_6":
		instance.light_color = Color.REBECCA_PURPLE
	
	instance.global_position = coords
		
	get_tree().root.add_child(instance)
