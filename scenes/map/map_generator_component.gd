extends Node
class_name WorldGeneratorComponent

@export var num_tiles_wide: int = 100
@export var num_tiles_deep: int = 300 

var grid: Array = []

var tiles = {
	"rock": 0
}

func _init() -> void:
	grid = []
	for x in num_tiles_wide:
		grid.append([])
		for y in num_tiles_deep:
			grid[x].append(-1)

func generate_world(tile_map_layer: TileMapLayer) -> void:
	for x in num_tiles_wide:
		for y in num_tiles_deep:
			var coords = Vector2(x, y)
			var rock_coords = Vector2(0,0)
			var dirt_coords = Vector2(1, 0)
			tile_map_layer.set_cell(coords, 0, dirt_coords, 0)
			print(tile_map_layer.get_cell_tile_data(coords))
			
