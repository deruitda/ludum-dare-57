extends Node
class_name WorldGeneratorComponent

var rng: RandomNumberGenerator
@export var seed: String
func _ready() -> void:
	
	rng = RandomNumberGenerator.new()
	if seed:
		rng.seed = hash(seed)

func generate_world(tile_map_layer: WorldTileMapLayer) -> void:
	var tile_resources = []
	var weights = []
	var number_of_tile_resources: int = 0
	if tile_map_layer.variable_tile_resource_list:
		weights = tile_map_layer.variable_tile_resource_list.get_tile_resource_percentage_weight_list()
		tile_resources = tile_map_layer.variable_tile_resource_list.get_tile_resource_list()
		number_of_tile_resources = tile_resources.size()
		weights.push_back(1)
	
	for x in tile_map_layer.num_tiles_wide:
		for y in tile_map_layer.num_tiles_deep:
			var coords = Vector2(x, y)
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

		
			
