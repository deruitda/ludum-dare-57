extends CanvasLayer

@onready var topRight: AnimatedSprite2D = $TopRightContainer/TopRight
@onready var topLeft: AnimatedSprite2D = $TopLeftContainer/TopLeft
@onready var bottomRight: AnimatedSprite2D = $BottomRightContainer/BottomRight
@onready var bottomLeft: AnimatedSprite2D = $BottomLeftContainer/BottomLeft
@onready var bottom: AnimatedSprite2D = $BottomContainer/Bottom
@onready var top: AnimatedSprite2D = $TopContainer/Top
@onready var right: AnimatedSprite2D = $RightContainer/Right
@onready var left: AnimatedSprite2D = $LeftContainer/Left
@export var player: Node2D

@export var max_vertical_distance: float = 450
@export var max_diagonal_distance: float = 900
@export var max_horizontal_distance: float = 800


func _ready() -> void:
	SignalBus.resource_pinged.connect(show_pointer)
	
	
func show_pointer(coords: Vector2, tile_resource: TileResource):
	var player_vec = Vector2(player.position.x, player.position.y)
	var distance_to_resource = player_vec.distance_to(coords)
	
	var angle: float = rad_to_deg(player_vec.angle_to_point(coords))
	
	# top right
	if angle <= 0 and angle >= -60 and distance_to_resource >= max_diagonal_distance:
		play_animation(topRight)	
	# top
	if angle <= -60 and angle >= -130 and distance_to_resource >= max_vertical_distance:
		play_animation(top)	
	# top left
	if angle <= -130 and angle >= -165 and distance_to_resource >= max_diagonal_distance:
		play_animation(topLeft)
	# left
	if angle <= -165 and angle <= 165 and distance_to_resource >= max_horizontal_distance:
		play_animation(left)
	# bottom left
	if angle >= -165 and angle >= 130 and distance_to_resource >= max_diagonal_distance:
		play_animation(bottomLeft)
	# bottom
	if angle <= 130 and angle >= 60 and distance_to_resource >= max_vertical_distance:
		play_animation(bottom)
	# bottom right
	if angle <= 60 and angle >= 15 and distance_to_resource >= max_diagonal_distance:
		play_animation(bottomRight)
	# right
	if angle <= 15 and angle >= -15 and distance_to_resource >= max_horizontal_distance:
		play_animation(right)

func play_animation(anim: AnimatedSprite2D):
	anim.visible = true
	anim.play("default")
