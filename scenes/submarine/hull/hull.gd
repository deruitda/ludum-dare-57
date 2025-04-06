extends Node2D
class_name Hull

@onready var decay_health_pulse_timer: Timer = $DecayHealthPulseTimer

@export var hull_resource: HullResource
@export var QUADRATIC_MULTIPLIER: float = 0.01

@onready var health: float = 100
@onready var is_destroyed: bool = false
@onready var decaying_potential_health_loss: float = 0.0
@onready var is_beyond_depth_threshold: bool = false

signal hull_destroyed

func update_depth(depth: float, delta: float) -> void:
	if depth > hull_resource.max_depth_for_full_integrity:
		is_beyond_depth_threshold = true
		var over_depth = depth - hull_resource.max_depth_for_full_integrity
		var current_decay_rate = pow(over_depth, 2) * delta * QUADRATIC_MULTIPLIER
		
		decaying_potential_health_loss = decaying_potential_health_loss + current_decay_rate
		
		if decay_health_pulse_timer.is_stopped():
			decay_health_pulse_timer.start()
	
	else:
		is_beyond_depth_threshold = false
		decaying_potential_health_loss = 0.0
		if decay_health_pulse_timer.is_stopped()  == false:
			decay_health_pulse_timer.stop()


func remove_health_by_decay_rate(decay_rate: float) -> void:
		# Subtract from health
		health -= decay_rate

		# Clamp so health doesn't go negative
		health = max(health, 0.0)
		
		SignalBus.player_health_changed.emit(health)
		
		if health <= 0 and not is_destroyed:
			is_destroyed = true
			SignalBus.submarine_destroyed.emit()
			hull_destroyed.emit()


func _on_decay_health_pulse_timer_timeout() -> void:
	remove_health_by_decay_rate(decaying_potential_health_loss)
	decaying_potential_health_loss = 0.0
