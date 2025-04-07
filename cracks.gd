extends CanvasLayer
@onready var texture_rect_1: TextureRect = $TextureRect1
@onready var texture_rect_2: TextureRect = $TextureRect2
@onready var texture_rect_3: TextureRect = $TextureRect3
@onready var texture_rect_4: TextureRect = $TextureRect4

func _ready() -> void:
	SignalBus.hull_health_updated.connect(update_screen)

	
func update_screen(hull: Hull):
	var hp_percent = hull.get_hull_health_percentage()
	var animated = null
	
	if hp_percent < 25:
		animated = texture_rect_1.texture as AnimatedTexture
	if hp_percent < 50:
		animated = texture_rect_2.texture as AnimatedTexture
	if hp_percent < 75:
		animated = texture_rect_3.texture as AnimatedTexture
	if hp_percent < 100:
		animated = texture_rect_4.texture as AnimatedTexture
		
	run_animation(animated)

func run_animation(animated_texture: AnimatedTexture):
	animated_texture.visible = true
	animated_texture.pause = false
	animated_texture.one_shot = true
	animated_texture.speed_scale = 1.0
