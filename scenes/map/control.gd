extends Container
class_name TileVariableControl

@export var variable_tile_resource_list: VariableTileResourceList
@export var default_tile: TileResource = preload("res://scenes/map/tiles/dirt.tres")

func get_starting_tile() -> Vector2:
	return Vector2(roundi(position.x / GameState.PIXEL_SIZE), roundi(position.y / GameState.PIXEL_SIZE))

func get_number_of_tiles_wide() -> int:
	return roundi(size.x / GameState.PIXEL_SIZE) * scale.x

func get_number_of_tiles_deep() -> int:
	return roundi(size.y / GameState.PIXEL_SIZE) * scale.y
