extends Resource
class_name ZoneResourceListLayer

@export var max_depth_percentage: float 
@export var variable_tile_resource_list: VariableTileResourceList


func get_max_depth() -> float: 
	const total_max_depth = GameState.TOTAL_DEPTH / GameState.PIXEL_SIZE
	return total_max_depth * max_depth_percentage
