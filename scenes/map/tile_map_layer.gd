extends TileMapLayer
class_name WorldTileMapLayer
@export var world_generator_component: WorldGeneratorComponent
@export var base_tile_metadata: MineralResource

func _ready() -> void:
	world_generator_component.generate_world(self)
