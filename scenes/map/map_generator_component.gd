extends Node
class_name WorldGeneratorComponent

@export var num_tiles_wide: int = 100
@export var num_tiles_deep: int = 300 
@export var root_coordinates: Vector2 = Vector2(0,0)

var grid: Array = []

var rng: RandomNumberGenerator
@export var seed: String
func _ready() -> void:
	grid = []
	for x in num_tiles_wide:
		grid.append([])
		for y in num_tiles_deep:
			grid[x].append(-1)
			
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
	
	for x in num_tiles_wide:
		for y in num_tiles_deep:
			var coords = Vector2(x, y) + root_coordinates
			# If a tile is predefined, do not randomly generate
			if tile_map_layer.get_cell_tile_data(coords) != null:
				continue
			if number_of_tile_resources == 0:
				tile_map_layer.set_cell(coords, 0, tile_map_layer.base_tile_metadata.atlas_coordinates, 0)
				continue

			var index = rng.rand_weighted(weights)
			if(index < number_of_tile_resources):
				tile_map_layer.set_cell(coords, 0, tile_resources.get(index).atlas_coordinates, 0)
			else:
				tile_map_layer.set_cell(coords, 0, tile_map_layer.base_tile_resource.atlas_coordinates, 0)
				
			
