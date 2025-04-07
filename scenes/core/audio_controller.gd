extends Node2D

@export var mute: bool = false
@export var audio_stream_player: AudioStreamPlayer2D
@onready var ambient_player: AudioStreamPlayer2D = $AmbientPlayer
@onready var sfx_player: AudioStreamPlayer2D = $SfxPlayer

var surface_audio = [
	preload("res://assets/audio/sfx/waves.wav")
]
var edmund_audio = [
	preload("res://assets/audio/music/Final_whistle.wav")
]

func _ready():
	SignalBus.sell_cargo.connect(play_money)
	SignalBus.player_has_won.connect(_on_player_has_won)
	
	if not mute:
		play_music()
		
func play_money():
	sfx_player.play()
		
func play_music():
	if not mute:
		audio_stream_player.play()

func _process(delta: float) -> void:
	if GameState.depth < 4 and !ambient_player.playing:
		ambient_player.stream = surface_audio[0]
		ambient_player.play()	
	if GameState.depth > 182.0 and !ambient_player.playing:
		ambient_player.stream = edmund_audio[0]
		ambient_player.play()
	if GameState.depth > 175:
		audio_stream_player.stop()

func _on_player_has_won() -> void:
	ambient_player.stream = edmund_audio[0]
	ambient_player.play()
