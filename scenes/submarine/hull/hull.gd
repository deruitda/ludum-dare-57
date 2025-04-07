extends Node2D
class_name Hull

@onready var decay_health_pulse_timer: Timer = $DecayHealthPulseTimer

@export var hull_resource: HullResource
@export var QUADRATIC_MULTIPLIER: float = 0.01

@onready var health: float = 100
@onready var is_destroyed: bool = false
@onready var decaying_potential_health_loss: float = 0.0
@onready var is_beyond_depth_threshold: bool = false
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

signal hull_upgraded(hull: Hull)

func _ready() -> void:
	SignalBus.purchase_completed.connect(_shop_item_purchased)


func _physics_process(delta: float) -> void:
	update_depth(GameState.depth, delta)


func _shop_item_purchased(shop_item_resource: ShopItemResource):
	assert(shop_item_resource.item_resource != null)
	if shop_item_resource.item_resource is HullResource:
		upgrade_hull(shop_item_resource.item_resource)
	elif shop_item_resource.item_resource is RepairHullResource:
		repair_hull()


func update_depth(depth: float, delta: float) -> void:
	var percentage_depth = depth / (GameState.TOTAL_DEPTH / GameState.PIXEL_SIZE)
	
	if percentage_depth > hull_resource.max_depth_percentage_for_full_integrity:
		is_beyond_depth_threshold = true
		
		var depth_allowed = (GameState.TOTAL_DEPTH / GameState.PIXEL_SIZE) * hull_resource.max_depth_percentage_for_full_integrity
		var damage_depth = depth - depth_allowed
		# Quadratic decay based on % over safe depth
		var current_decay_rate = pow(damage_depth, 2) * delta * QUADRATIC_MULTIPLIER
		decaying_potential_health_loss = decaying_potential_health_loss + current_decay_rate
		
		if decay_health_pulse_timer.is_stopped():
			decay_health_pulse_timer.start()
			
		var safe_depth = hull_resource.max_depth_percentage_for_full_integrity
		var normalized_depth = (percentage_depth - safe_depth) / (1.0 - safe_depth)
		var normalized_depth_percentage = clamp(normalized_depth, 0.0, 1.0)
		SignalBus.set_normalized_depth_percentage.emit(normalized_depth_percentage)
	
	else:
		is_beyond_depth_threshold = false
		decaying_potential_health_loss = 0.0
		SignalBus.set_normalized_depth_percentage.emit(0.0)
		
		if decay_health_pulse_timer.is_stopped()  == false:
			decay_health_pulse_timer.stop()


func remove_health(amount: float) -> void:
		# Subtract from health
		var _health = health - amount
		set_health(_health)
		
		if !audio_stream_player_2d.playing:
			audio_stream_player_2d.play()

func set_health(_health: float):
	health = max(min(_health, hull_resource.max_health), 0.0)
	SignalBus.hull_health_updated.emit(self)
	
	if health == 0.0 and not is_destroyed:
		is_destroyed = true
		SignalBus.hull_destroyed.emit()
	
func _on_decay_health_pulse_timer_timeout() -> void:
	remove_health(decaying_potential_health_loss)
	decaying_potential_health_loss = 0.0

func repair_hull():
	set_health(hull_resource.max_health)

func respawn():
	repair_hull()
	is_destroyed = false

func upgrade_hull(new_hull_resource: HullResource) -> void:
	hull_resource = new_hull_resource
	repair_hull()
	print("in hull")
	hull_upgraded.emit(self)
	
	
func get_hull_health_percentage() -> float:
	return health / hull_resource.max_health
