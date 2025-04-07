extends Node
class_name WorldGeneratorComponent

var rng: RandomNumberGenerator
@export var seed: String
@export var root_position: Vector2 = Vector2(-50, 0.0)

func _ready() -> void:
	
	rng = RandomNumberGenerator.new()
	if seed:
		rng.seed = hash(seed)


func generate_map_from_control(tile_map_layer: WorldTileMapLayer, tile_variable_control: TileVariableControl):
	var variable_tile_resource_list = tile_variable_control.variable_tile_resource_list
	var get_starting_position = tile_variable_control.get_starting_tile()
	var num_tiles_wide = tile_variable_control.get_number_of_tiles_wide()
	var num_tiles_deep = tile_variable_control.get_number_of_tiles_deep()
	
	var weights = variable_tile_resource_list.get_tile_resource_percentage_weight_list(true)
	var default_tile = tile_variable_control.default_tile
	var number_of_tile_resources = variable_tile_resource_list.variable_tile_resources.size()
	var tile_resources = variable_tile_resource_list.get_tile_resource_list()
	
	for y in num_tiles_deep:
		for x in tile_map_layer.num_tiles_wide:
			var coords = Vector2(x, y) + get_starting_position
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
				tile_map_layer.set_tile_resource(tile_resource, coords, 0)
func generate_world(tile_map_layer: WorldTileMapLayer) -> void:
	for tile_variable_control in tile_map_layer.tile_variable_controls:
		generate_map_from_control(tile_map_layer, tile_variable_control)
	#for y in tile_map_layer.num_tiles_deep:
		#if y > current_zone_resource_list_layer.get_max_depth() and zone_resource_list_layers.size() - 1 > i:
			#i = i + 1
			#current_zone_resource_list_layer = zone_resource_list_layers.get(i)
			#current_variable_tile_resource_list = current_zone_resource_list_layer.variable_tile_resource_list
			#weights = current_variable_tile_resource_list.get_tile_resource_percentage_weight_list(true)
			#tile_resources = current_variable_tile_resource_list.get_tile_resource_list()
			#
			#number_of_tile_resources = tile_resources.size()
			#max_depth = tile_map_layer.num_tiles_deep / current_zone_resource_list_layer.max_depth_percentage
			#
		#for x in tile_map_layer.num_tiles_wide:
			#var coords = Vector2(x, y) + root_position
			#var tile_resource: TileResource = null
			#var tile_data = tile_map_layer.get_cell_tile_data(coords)
			#if tile_data:
				##get tile resource from tile data
				#tile_resource = tile_data.get_custom_data("tile_resource")
			#
			## If a tile is predefined, do not randomly generate
			#if(tile_resource == null):
				#var index = rng.rand_weighted(weights)
				#if(index < number_of_tile_resources):
					#tile_resource = tile_resources.get(index)
				#else:
					#tile_resource = tile_map_layer.base_tile_resource
			#
			#if tile_resource is TileResource:
				#tile_map_layer.set_tile_resource(tile_resource, coords, 0)

		
			
