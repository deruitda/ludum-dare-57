extends Node
class_name WorldGeneratorComponent

var rng: RandomNumberGenerator
@export var seed: String
@export var root_position: Vector2 = Vector2(-50, 0.0)

func _ready() -> void:
	
	rng = RandomNumberGenerator.new()
	if seed:
		rng.seed = hash(seed)

func generate_world(tile_map_layer: WorldTileMapLayer) -> void:
	var tile_resources = []
	var weights = []
	var number_of_tile_resources: int = 0
	var zone_resource_list_layers = tile_map_layer.zone_resource_list_layers.duplicate(true)
	var i = 0
	var current_zone_resource_list_layer = zone_resource_list_layers.get(i)
	var current_variable_tile_resource_list = current_zone_resource_list_layer.variable_tile_resource_list
	var max_depth: float = 0.0
	if current_variable_tile_resource_list:
		
		weights = current_variable_tile_resource_list.get_tile_resource_percentage_weight_list(true)
		tile_resources = current_variable_tile_resource_list.get_tile_resource_list()
		number_of_tile_resources = tile_resources.size()
		max_depth = tile_map_layer.num_tiles_deep / current_zone_resource_list_layer.max_depth_percentage
	
	for y in tile_map_layer.num_tiles_deep:
		if y > current_zone_resource_list_layer.get_max_depth() and zone_resource_list_layers.size() - 1 > i:
			i = i + 1
			current_zone_resource_list_layer = zone_resource_list_layers.get(i)
			current_variable_tile_resource_list = current_zone_resource_list_layer.variable_tile_resource_list
			weights = current_variable_tile_resource_list.get_tile_resource_percentage_weight_list(true)
			tile_resources = current_variable_tile_resource_list.get_tile_resource_list()
			max_depth = tile_map_layer.num_tiles_deep / current_zone_resource_list_layer.max_depth_percentage
			
		for x in tile_map_layer.num_tiles_wide:
			var coords = Vector2(x, y) + root_position
			var tile_resource: TileResource = null
			var tile_data = tile_map_layer.get_cell_tile_data(coords)
			if tile_data:
				#get tile resource from tile data
				tile_resource = tile_data.get_custom_data("tile_resource")
			
			# If a tile is predefined, do not randomly generate
			if(tile_resource == null):
				var index = rng.rand_weighted(weights)
				if(index < number_of_tile_resources):
					tile_resource = tile_resources.get(index)
				else:
					tile_resource = tile_map_layer.base_tile_resource
			
			if tile_resource is TileResource:
				tile_map_layer.set_tile_resource(tile_resource, coords)

		
			
