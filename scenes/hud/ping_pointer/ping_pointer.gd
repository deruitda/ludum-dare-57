extends CanvasLayer

func _ready() -> void:
	SignalBus.resource_pinged.connect(show_pointer)
	
	
func show_pointer(coords: Vector2, tile_resource: TileResource):
	var a = coords
	
