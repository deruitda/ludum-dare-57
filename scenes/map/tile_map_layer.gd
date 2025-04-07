extends TileMapLayer
class_name WorldTileMapLayer

@export var tile_variable_controls: Array[TileVariableControl]

@export var num_tiles_wide: int = 250
@export var num_tiles_deep: int = 185 
@export var world_generator_component: WorldGeneratorComponent
@export var base_tile_resource: TileResource
@export var zone_resource_list_layers: Array[ZoneResourceListLayer]

@export var drilled_tile_space: TileResource
@export var drilling_resource: TileResource

func _ready() -> void:
	world_generator_component.generate_world(self)

func set_tile_resource(tile_resource: TileResource, coords: Vector2, source_tile_set_id: int) -> void:
	var atlas_coords = tile_resource.atlas_coordinates
	self.set_cell(coords, source_tile_set_id, tile_resource.atlas_coordinates, 0)

func get_tile_resource_from_rid(rid: RID) -> TileResource:
	var coords = self.get_coords_for_body_rid(rid)
	var tileData = self.get_cell_tile_data(coords)
	var tile_resource = tileData.get_custom_data("tile_resource")
	
	return tile_resource
	
func get_tile_global_position(rid: RID) -> Vector2:
	var coords = self.get_coords_for_body_rid(rid)
	var global_coords = map_to_local(coords)
	
	return global_coords

func drill_tile(rid: RID) -> void:
	var coords = self.get_coords_for_body_rid(rid)
	set_tile_resource(drilled_tile_space, coords, 0)
	
func drilling_tile(rid: RID) -> void:
	var coords = self.get_coords_for_body_rid(rid)
	var resource = get_tile_resource_from_rid(rid)
	
	set_tile_resource(drilling_resource, coords, resource.anim_source_index)
	
func abort_drilling(rid: RID) -> void:
	var coords = self.get_coords_for_body_rid(rid)
	var resource = get_tile_resource_from_rid(rid)
	
	set_tile_resource(resource, coords, 0)
