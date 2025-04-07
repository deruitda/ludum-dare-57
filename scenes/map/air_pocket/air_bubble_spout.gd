extends Node2D

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

	bubble.name = "Bubble"
	bubble.global_position = global_position  # or wherever you want it to spawn

	get_tree().current_scene.add_child(bubble)
	
#
func _physics_process(delta: float) -> void:
	current_timer += delta
	if current_timer > spawn_in_seconds:
		_on_spawn_timer_timeout()
		current_timer -= spawn_in_seconds
	
	#for col in air_particles:
		#var trans = PhysicsServer2D.body_get_state(col[0], PhysicsServer2D.BODY_STATE_TRANSFORM)
		#trans.origin = trans.origin - global_position
		#RenderingServer.canvas_item_set_transform(col[1], trans)
		#if trans.origin.y + global_position.y < 0.0:
			#PhysicsServer2D.free_rid(col[0])
			#RenderingServer.free_rid(col[1])
			#air_particles.erase(col)
			#current_particle_count -= 1
			

func _on_spawn_timer_timeout() -> void:
	if current_particle_count < max_air_particles:
		create_particle()
		current_particle_count += 1
