extends Resource
class_name VariableTileResourceList

@export var variable_tile_resources: Array[VariableTileResource]

func get_tile_resource_percentage_weight_list() -> Array:
	var vtrs = variable_tile_resources.map(func(variable_tile_resource: VariableTileResource): return variable_tile_resource.percent_chance_of_spawn)
	return vtrs

func get_tile_resource_list() -> Array:
	return variable_tile_resources.map(func(variable_tile_resource): return variable_tile_resource.tile_resource)
