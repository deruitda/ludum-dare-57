extends Node2D
class_name Hull

@export var hull_resource: HullResource
@export var QUADRATIC_MULTIPLIER: float = 0.01
@onready var health: float = 100

signal hull_destroyed

func update_depth(depth: float, delta: float) -> void:
	if depth > hull_resource.max_depth_for_full_integrity:
		var over_depth = depth - hull_resource.max_depth_for_full_integrity
		var decay_rate = pow(over_depth, 2) * delta * QUADRATIC_MULTIPLIER
		remove_health_by_decay_rate(decay_rate)

func remove_health_by_decay_rate(decay_rate: float) -> void:
		# Subtract from health
		health -= decay_rate

		# Clamp so health doesn't go negative
		health = max(health, 0.0)
		
		SignalBus.player_health_changed.emit(health)
		
		if health <= 0:
			hull_destroyed.emit()
