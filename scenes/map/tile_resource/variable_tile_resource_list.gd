extends Resource
class_name VariableTileResourceList

@export var variable_tile_resources: Array[VariableTileResource]

func get_tile_resource_percentage_weight_list(append_default_tile_weight: bool) -> Array:
	var vtrs = variable_tile_resources.map(func(variable_tile_resource: VariableTileResource): return variable_tile_resource.percent_chance_of_spawn)
	if append_default_tile_weight:
		var current_sum_of_weight = max(0.0, min(1.0, vtrs.reduce(func(accum, n_perc): return accum + n_perc, 0.0)))
		vtrs.append(1 - current_sum_of_weight)
	return vtrs

func get_tile_resource_list() -> Array:
	return variable_tile_resources.map(func(variable_tile_resource): return variable_tile_resource.tile_resource)
