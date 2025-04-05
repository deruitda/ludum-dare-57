extends TileMapLayer
class_name WorldTileMapLayer
@export var num_tiles_wide: int = 100
@export var num_tiles_deep: int = 300 
@export var world_generator_component: WorldGeneratorComponent
@export var base_tile_resource: TileResource
@export var variable_tile_resource_list: VariableTileResourceList

@export var drilled_tile_space: TileResource

func _ready() -> void:
	world_generator_component.generate_world(self)

func set_tile_resource(tile_resource: TileResource, coords: Vector2) -> void:
	var atlas_coords = tile_resource.atlas_coordinates
	self.set_cell(coords, 0, tile_resource.atlas_coordinates, 0)

func get_tile_resource_from_rid(rid: RID) -> TileResource:
	var coords = self.get_coords_for_body_rid(rid)
	var tileData = self.get_cell_tile_data(coords)
	var tile_resource = tileData.get_custom_data("tile_resource")
		
	return tile_resource

func drill_tile(rid: RID) -> void:
	var coords = self.get_coords_for_body_rid(rid)
	set_tile_resource(drilled_tile_space, coords)
	
