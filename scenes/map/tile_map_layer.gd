extends TileMapLayer
class_name WorldTileMapLayer
@export var num_tiles_wide: int = 100
@export var num_tiles_deep: int = 300 
@export var world_generator_component: WorldGeneratorComponent
@export var base_tile_resource: TileResource
@export var variable_tile_resource_list: VariableTileResourceList

func _ready() -> void:
	world_generator_component.generate_world(self)

func set_tile_resource(tile_resource: TileResource, coords: Vector2) -> void:
	var atlas_coords = tile_resource.atlas_coordinates
	self.set_cell(coords, 0, tile_resource.atlas_coordinates, 0)
