extends CharacterBody2D
@export var speed = 400

@export var move_to_center_component: MoveToCenterComponent
@onready var ship_light: PointLight2D = $ShipLight
@onready var hull_sprite: Sprite2D = %HullSprite2D

@export var velocity_component: VelocityComponent
@export var edge_detector: EdgeDetector
@export var hull: Hull
@export var checkpoint: Checkpoint
@export var drill: Drill
@export var submarine_sprite: Sprite2D

@onready var current_depth: float
@onready var direction_input: Vector2 = Vector2.ZERO
@onready var jet_light: PointLight2D = $JetLight
@onready var battery: Battery = $Battery
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D


var audio = [
 	preload("res://assets/audio/sfx/prop_start.wav"),
 	preload("res://assets/audio/sfx/prop_sustain.wav"),
 	preload("res://assets/audio/sfx/prop_end.wav"),
 ]

var min_light_energy = 1.0
var max_light_energy = 5.0

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
		modulate_jet_light()
		velocity_component.set_current_rotation(rotation_degrees)
		
		
	velocity_component.do_character_move(self)

#func set_edge_detection():
	#var edge_directions: Array[Vector2] = edge_detector.get_edge_directions()
	##for edge_direction in edge_directions:
		##velocity_component.set_collision_direction(edge_direction)
	#
		#if edge_directions.size() > 0:
			#move_to_center_component.set_must_move_to_center()

func do_respawn():
	if checkpoint:
		hull.respawn()
		battery.fully_charge_battery()
		velocity_component.set_velocity(Vector2.ZERO)
		global_position = checkpoint.get_spawn_position()

func apply_movement_effects():
	
	if velocity_component.velocity.length() > 0:
		jet_light.energy = velocity_component.velocity.length() / 100
	elif velocity_component.velocity.length() == 0:
		jet_light.energy = 0.0	
	
	# the player is stopped, set the sustained sound
	if audio_stream_player_2d.stream == null || audio_stream_player_2d.stream == audio[2]:
		if velocity_component.is_moving() && !audio_stream_player_2d.playing:
			audio_stream_player_2d.stream = audio[0]
			audio_stream_player_2d.play()
			
	# if we've played the start sound and are moving, play sustained
	if audio_stream_player_2d.stream == audio[0] && !audio_stream_player_2d.playing && velocity_component.is_moving():
		audio_stream_player_2d.stream = audio[1]
		audio_stream_player_2d.play()
		
	# if we're moving and are now stopped, play the stop sound
	if audio_stream_player_2d.stream == audio[1] && !velocity_component.is_moving():
		audio_stream_player_2d.stream = audio[2]
		audio_stream_player_2d.play()

func modulate_jet_light():
	pass
	#var current_energy = jet_light.energy

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
	SignalBus.hull_destroyed.connect(do_respawn)
	SignalBus.submarine_lost_power.connect(do_respawn)
	if hull.hull_resource.hull_sprite:
		hull_sprite.texture = hull.hull_resource.hull_sprite
	
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

func _on_hull_upgraded(hull: Hull) -> void:
	hull_sprite.texture = hull.hull_resource.hull_sprite



func _on_hull_hull_upgraded(_hull: Hull) -> void:
	if _hull.hull_resource.hull_sprite:
		hull_sprite.texture = _hull.hull_resource.hull_sprite
