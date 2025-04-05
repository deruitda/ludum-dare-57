extends TileMapLayer
class_name WorldTileMapLayer
@export var world_generator_component: WorldGeneratorComponent
@export var base_tile_metadata: MineralResource
@export var variable_mineral_resource_list: VariableMineralResourceList
func _ready() -> void:
	world_generator_component.generate_world(self)
