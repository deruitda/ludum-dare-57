extends TileMapLayer
class_name WorldTileMapLayer
@export var world_generator_component: WorldGeneratorComponent
@export var base_tile_resource: TileResource
@export var variable_tile_resource_list: VariableTileResourceList
func _ready() -> void:
	world_generator_component.generate_world(self)
