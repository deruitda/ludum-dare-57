extends Node2D
class_name Drill

func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if !body is WorldTileMapLayer:
		pass
		
	var tile_resource = body.get_tile_resource_from_rid(body_rid)
	if (tile_resource is ValuableTileResource):
		SignalBus.add_cargo.emit(tile_resource)
	
	body.drill_tile(body_rid)

func _on_area_2d_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	pass # Replace with function body.
