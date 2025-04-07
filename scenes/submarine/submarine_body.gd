extends CharacterBody2D
@export var speed = 400

@export var move_to_center_component: MoveToCenterComponent
@onready var ship_light: PointLight2D = $ShipLight
@export var velocity_component: VelocityComponent
@export var edge_detector: EdgeDetector
@export var hull: Hull
@export var checkpoint: Checkpoint
@export var drill: Drill
@export var submarine_sprite: Sprite2D
@onready var radar: Node2D = $Radar
@onready var flashlight: Node2D = $Flashlight
@onready var current_depth: float
@onready var direction_input: Vector2 = Vector2.ZERO
@onready var jet_light: PointLight2D = $JetLight
@onready var battery: Battery = $Battery
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var power_loss_audio_player: AudioStreamPlayer2D = $PowerLossAudioPlayer
@onready var explosion_audio_player: AudioStreamPlayer2D = $ExplosionAudioPlayer

var is_dead = false

var audio = [
 	preload("res://assets/audio/sfx/prop_start.wav"),
 	preload("res://assets/audio/sfx/prop_sustain.wav"),
 	preload("res://assets/audio/sfx/prop_end.wav"),
 ]

var min_light_energy = 1.0
var max_light_energy = 2.0

func _process(delta: float) -> void:
	direction_input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	current_depth = global_position.y / GameState.PIXEL_SIZE
	SignalBus.set_current_depth.emit(current_depth)

func _physics_process(delta: float):
	drill.set_current_input_direction(direction_input)
	apply_rotation()
	apply_depth_effects()
	apply_movement_effects()

	# stream check is a hack to prevent gravity from being applied at the beginning of the game
	if current_depth < 0.4 && audio_stream_player_2d.stream != null:
		velocity_component.apply_gravity(delta)
	else:
		move_to_center_component.set_current_position_value(global_position)
		move_to_center_component.set_current_velocity(velocity)
		
		if drill.is_actively_drilling:
			move_to_center_component.set_current_input_direction(Vector2.ZERO)
			move_to_center_component.set_must_move_to_center()
			
		var edge_directions: Array[Vector2] = edge_detector.get_edge_directions()
		
		if edge_directions.size() > 0:
			move_to_center_component.start_timer()
		
		if move_to_center_component.is_currently_centering:
			var move_to_center_velocity: Vector2 = move_to_center_component.get_velocity_to_center()
			velocity_component.set_velocity(move_to_center_velocity)
		elif not drill.is_actively_drilling:
			velocity_component.apply_move(direction_input, delta)
			
		#set_edge_detection()
		
		hull.update_depth(current_depth, delta)
		GameState.update_depth(current_depth)
		velocity_component.set_current_rotation(rotation_degrees)
		
	if !is_dead:
		velocity_component.do_character_move(self)

#func set_edge_detection():
	#var edge_directions: Array[Vector2] = edge_detector.get_edge_directions()
	##for edge_direction in edge_directions:
		##velocity_component.set_collision_direction(edge_direction)
	#
		#if edge_directions.size() > 0:
			#move_to_center_component.set_must_move_to_center()

func die_hull():
	explosion_audio_player.play()
	die()

func die_power():
	power_loss_audio_player.play()
	die()

func die():
	is_dead = true
	drill.visible = false
	radar.visible = false
	flashlight.visible = false
	jet_light.visible = false
	hull.begin_die()


func _on_hull_hull_done_dying() -> void:
	do_respawn()

func do_respawn():
	if checkpoint:
		hull.respawn()
		battery.fully_charge_battery()
		velocity_component.set_velocity(Vector2.ZERO)
		global_position = checkpoint.get_spawn_position()
		drill.visible = true
		radar.visible = true
		flashlight.visible = true
		jet_light.visible = true
		is_dead = false

func apply_movement_effects():
	
	if current_depth > 1 and velocity_component.velocity.length() > 0:
		jet_light.energy = velocity_component.velocity.length() / 100
		gpu_particles_2d.emitting = true
		var num_particles = velocity_component.velocity.length()
		gpu_particles_2d.process_material.radial_velocity_max = num_particles
	elif velocity_component.velocity.length() == 0 or current_depth < 0.4:
		jet_light.energy = 0.0	
		gpu_particles_2d.emitting = false

	# if moving, play sustained prop sound
	if direction_input != Vector2.ZERO && velocity_component.is_moving() && !audio_stream_player_2d.playing:
		audio_stream_player_2d.stream = audio[1]
		audio_stream_player_2d.play()
		
	# if was moving but now no direction stop
	if direction_input == Vector2.ZERO && audio_stream_player_2d.playing && audio_stream_player_2d.stream == audio[1]:
		audio_stream_player_2d.stream = audio[2]
		audio_stream_player_2d.play()

func apply_rotation() -> void:
	var normal_x = direction_input.x
	if normal_x < 0:
		normal_x = normal_x * -1
		
	var normal_y = direction_input.y
	if normal_y < 0:
		normal_y = normal_y * -1
		
	if normal_y > normal_x:
		if direction_input.y > 0:
			rotation_degrees = -90.0
		else:
			rotation_degrees = 90.0
	elif normal_y < normal_y:
		if direction_input.x > 0:
			rotation_degrees = 180.0
		else:
			rotation_degrees = 0.0
		
		
	var left_right_vector = Helpers.get_left_right_input_from_vector(direction_input)
	if left_right_vector == Vector2.LEFT:
		rotation_degrees = 0.0
	elif left_right_vector == Vector2.RIGHT:
		rotation_degrees = 180.0

func apply_depth_effects():
	apply_ship_light()


func apply_ship_light():
	if current_depth >= 20:
		ship_light.enabled = true
		var energy = ship_light.energy
		var lerped = lerp(energy, max_light_energy, 0.1)
		ship_light.energy = lerped
	else:
		ship_light.enabled = false
		ship_light.energy = 0

func _ready() -> void:
	drill._on_drilling_aborted.connect(_on_drilling_aborted)
	drill._on_drilling_started.connect(_on_drilling_started)
	SignalBus.hull_destroyed.connect(die_hull)
	SignalBus.submarine_lost_power.connect(die_power)
	
func _on_drilling_started() -> void:
	move_to_center_component.set_must_move_to_center()

func _on_down_ray_cast_2d_on_collision() -> void:
	velocity_component.apply_collision(Vector2.DOWN)
	pass # Replace with function body.

func _on_left_ray_cast_2d_on_collision() -> void:
	velocity_component.apply_collision(Vector2.LEFT)
	pass # Replace with function body.

func _on_right_ray_cast_2d_on_collision() -> void:
	velocity_component.apply_collision(Vector2.RIGHT)
	pass # Replace with function body.

func _on_up_ray_cast_2d_on_collision() -> void:
	velocity_component.apply_collision(Vector2.UP)
	pass # Replace with function body.
func _on_drilling_aborted() -> void:
	pass
