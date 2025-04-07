extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var light: PointLight2D = $PointLight2D
@export var battery: Battery
@onready var power_consumption_component: PowerConsumptionComponent = $PowerConsumptionComponent
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var flashlight_resource: FlashlightResource

var audio = [
	preload("res://assets/audio/sfx/flashlight.wav"),
	preload("res://assets/audio/sfx/radar_arm.wav")
]

func _ready() -> void:
	SignalBus.toggle_flashlight.connect(_on_toggle_flashlight)
	SignalBus.purchase_completed.connect(_on_purchase_completed)
	if flashlight_resource:
		light.texture = flashlight_resource.light_texture

func _process(delta: float) -> void:
	if light.enabled:
		battery.consume_power(power_consumption_component.power_consumption_per_use * delta)

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_F and !animated_sprite.is_playing():
			toggle_flashlight()

# Handler of toggle flashlight signal
func _on_toggle_flashlight():
	toggle_flashlight()

func toggle_flashlight():
	if not flashlight_resource:
		return
	if !light.enabled:
		animated_sprite.play("open")
	else:
		animated_sprite.play("close")
	
	audio_stream_player_2d.stream = audio[1]
	audio_stream_player_2d.play()
		
func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "open":
		light.enabled = true
		audio_stream_player_2d.stream = audio[0]
		audio_stream_player_2d.play()


func _on_animated_sprite_2d_animation_changed() -> void:
	if animated_sprite.animation == "close":
		light.enabled = false

func _on_purchase_completed(purchased_shop_item_resource: ShopItemResource) -> void:
	if purchased_shop_item_resource.item_resource is FlashlightResource:
		flashlight_resource = purchased_shop_item_resource.item_resource
		light.texture = flashlight_resource.light_texture
		
