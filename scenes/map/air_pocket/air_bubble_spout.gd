extends Node2D

@onready var particle_texture: Texture = preload("res://assets/png_files/bubble_sprite01.png")
@export var max_air_particles: int = 1000

@export var spawn_in_seconds: float = 1.0
@onready var current_timer: float

@onready var current_particle_count = 0
@onready var air_particles: Array = []

@export var gravity: float = -2.0

const AIR_LAYER: int = 11
const CONNECTION_MASKS: Array[int] = [11] 

func create_particle():
	var particle_server = PhysicsServer2D
	var rendering_server = RenderingServer
	var trans = global_transform
	trans.origin += Vector2(randi_range(-10, 10), randi_range(-10, 10))
	
	var air_col = particle_server.body_create()
	particle_server.body_set_mode(air_col, PhysicsServer2D.BODY_MODE_RIGID)
	particle_server.body_set_space(air_col, get_world_2d().space)

	var shape = particle_server.circle_shape_create()
	particle_server.shape_set_data(shape, 8)
	particle_server.body_add_shape(air_col, shape, Transform2D.IDENTITY)

	particle_server.body_set_collision_layer(air_col, 1 << 10)
	particle_server.body_set_collision_mask(air_col, 1 << 0 | 1 << 7 | 1 << 10 | 1 << 1 | 1 << 3)
	
	particle_server.body_set_param(air_col, PhysicsServer2D.BODY_PARAM_FRICTION, 0.0)
	particle_server.body_set_param(air_col, PhysicsServer2D.BODY_PARAM_MASS, 0.05)
	particle_server.body_set_param(air_col, PhysicsServer2D.BODY_PARAM_GRAVITY_SCALE, gravity)
	
	particle_server.body_set_state(air_col, PhysicsServer2D.BODY_STATE_TRANSFORM, trans)

	var air_particle = rendering_server.canvas_item_create()
	rendering_server.canvas_item_set_parent(air_particle, get_canvas_item())
	rendering_server.canvas_item_set_transform(air_particle, trans)
	
	var rect = Rect2()
	rect.position = Vector2(-8, -8)
	rect.size = particle_texture.get_size() / 2
	rendering_server.canvas_item_add_texture_rect(air_particle, rect, particle_texture)
	#rendering_server.canvas_item_set_self_modulate(air_particle, Color("ff00ff")
	air_particles.append([air_col, air_particle])

func _physics_process(delta: float) -> void:
	current_timer += delta
	if current_timer > spawn_in_seconds:
		_on_spawn_timer_timeout()
		current_timer -= spawn_in_seconds
	
	for col in air_particles:
		var trans = PhysicsServer2D.body_get_state(col[0], PhysicsServer2D.BODY_STATE_TRANSFORM)
		trans.origin = trans.origin - global_position
		RenderingServer.canvas_item_set_transform(col[1], trans)
		if trans.origin.y + global_position.y < 0.0:
			PhysicsServer2D.free_rid(col[0])
			RenderingServer.free_rid(col[1])
			air_particles.erase(col)
			current_particle_count -= 1
			

func _on_spawn_timer_timeout() -> void:
	if current_particle_count < max_air_particles:
		create_particle()
		current_particle_count += 1
