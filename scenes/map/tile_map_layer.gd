extends TileMapLayer
@export var world_generator_component: WorldGeneratorComponent

func _ready() -> void:
	world_generator_component.generate_world(self)
