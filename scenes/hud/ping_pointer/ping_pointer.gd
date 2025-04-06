extends CanvasLayer

@onready var topRight: AnimatedSprite2D = $TopRight
@onready var topLeft: AnimatedSprite2D = $TopLeft
@onready var bottomRight: AnimatedSprite2D = $BottomRight
@onready var bottomLeft: AnimatedSprite2D = $BottomLeft
@onready var bottom: AnimatedSprite2D = $Bottom
@onready var top: AnimatedSprite2D = $Top
@onready var right: AnimatedSprite2D = $Right
@onready var left: AnimatedSprite2D = $Left
@onready var player: Node2D = $"../Submarine"

@export var max_distance: float = 650

func _ready() -> void:
	SignalBus.resource_pinged.connect(show_pointer)
	
	
func show_pointer(coords: Vector2, tile_resource: TileResource):
	var player_vec = Vector2(player.position.x, player.position.y)
	var distance_to_resource = player_vec.distance_to(coords)
	
	if distance_to_resource <= max_distance:
		return
	
	var angle: float = rad_to_deg(player_vec.angle_to_point(coords))
	
	# top right
	if angle <= 0 and angle >= -60:
		play_animation(topRight)	
	# top
	if angle <= -60 and angle >= -130:
		play_animation(top)	
	# top left
	if angle <= -130 and angle >= -165:
		play_animation(topLeft)
	# left
	if angle <= -165 and angle <= 165:
		play_animation(left)
	# bottom left
	if angle >= -165 and angle >= 130:
		play_animation(bottomLeft)
	# bottom
	if angle <= 130 and angle >= 60:
		play_animation(bottom)
	# bottom right
	if angle <= 60 and angle >= 15:
		play_animation(bottomRight)
	# right
	if angle <= 15 and angle >= -15:
		play_animation(right)

func play_animation(anim: AnimatedSprite2D):
	anim.visible = true
	anim.play("default")
