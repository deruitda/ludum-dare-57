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
	
	if hp_percent <= 0 || hp_percent >= 1.0:
		texture_rect_1.visible = false
		texture_rect_2.visible = false
		texture_rect_3.visible = false
		texture_rect_4.visible = false
		return
	
	if hp_percent < 0.25:
		texture_rect_1.visible = true
		animated = texture_rect_1.texture as AnimatedTexture
	if hp_percent < 0.50 and hp_percent > 0.25:
		texture_rect_2.visible = true
		animated = texture_rect_2.texture as AnimatedTexture
	if hp_percent < 0.75 and hp_percent > 0.50:
		texture_rect_3.visible = true
		animated = texture_rect_3.texture as AnimatedTexture
	if hp_percent < 1.0 and hp_percent > 0.75:
		texture_rect_4.visible = true
		animated = texture_rect_4.texture as AnimatedTexture
	
	if animated != null:
		run_animation(animated)

func run_animation(animated_texture: AnimatedTexture):
	animated_texture.pause = false
	animated_texture.one_shot = true
	animated_texture.speed_scale = 1.0
