extends Node2D
class_name AirSpout
@onready var bubble_texture: Texture = preload("res://assets/png_files/bubble_sprite01.png")
@export var max_air_particles: int = 1000

@export var spawn_in_seconds: float = 1.0
@onready var current_timer: float

@onready var current_particle_count = 0
@onready var air_particles: Array = []

@export var gravity: float = -2.0

const AIR_LAYER: int = 11
const CONNECTION_MASKS: Array[int] = [11] 

func create_particle():
	var bubble_scene := preload("res://scenes/map/air_pocket/air_bubble.tscn")  # adjust path

	var bubble := bubble_scene.instantiate()

	# Random X offset within -16 to +16
	var x_offset := randf_range(-16, 16)
	var spawn_position := global_position + Vector2(x_offset, 0)
	
	bubble.name = "Bubble"
	bubble.global_position = spawn_position  # or wherever you want it to spawn
	bubble.air_spout = self
	get_tree().current_scene.add_child(bubble)
#
func _physics_process(delta: float) -> void:
	current_timer += delta
	if current_timer > spawn_in_seconds:
		_on_spawn_timer_timeout()
		current_timer -= spawn_in_seconds
	
	
func can_create_bubbles() -> bool:
	return current_particle_count < max_air_particles and GameState.TOTAL_ALLOWED_BUBBLES < GameState.total_bubbles

func _on_bubble_popped():
	max_air_particles -= 1
	GameState.total_bubbles -= 1

func _on_spawn_timer_timeout() -> void:
	if can_create_bubbles():
		create_particle()
		current_particle_count += 1
		GameState.total_bubbles += 1
