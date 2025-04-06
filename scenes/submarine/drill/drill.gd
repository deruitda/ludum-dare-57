extends Node2D
class_name Drill

@export var battery: Battery
@export var power_consuption_component: PowerConsumptionComponent
@export var drill_resource: DrillResource

@onready var is_actively_drilling: bool = false
@onready var active_drilling_rid: RID
@onready var active_drilling_world_tile_map_layer: WorldTileMapLayer

@onready var drill_timer: Timer = $DrillTimer

func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if !body is WorldTileMapLayer:
		pass
	
	if not is_actively_drilling:
		if not battery.has_enough_power_for(power_consuption_component.power_consumption_per_use):
			pass
		active_drilling_rid = body_rid
		active_drilling_world_tile_map_layer = body
		is_actively_drilling = true
		start_drilling()

func start_drilling() -> void:
	
	drill_timer.wait_time = drill_resource.drill_speed
	drill_timer.start()
	drill_timer.timeout.connect(_drilling_is_finished)

func _drilling_is_finished() -> void:
	if is_actively_drilling == false:
		pass
	is_actively_drilling = false
	if not battery.has_enough_power_for(power_consuption_component.power_consumption_per_use):
		pass
	
	active_drilling_world_tile_map_layer.drill_tile(active_drilling_rid)
	var tile_resource = active_drilling_world_tile_map_layer.get_tile_resource_from_rid(active_drilling_rid)
	if (tile_resource is ValuableTileResource):
		SignalBus.add_cargo.emit(tile_resource)

	

func _on_area_2d_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body_rid == active_drilling_rid:
		abort_drilling()
	pass # Replace with function body.
	
func abort_drilling():
	drill_timer.stop()
	is_actively_drilling = false
