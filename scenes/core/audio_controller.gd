extends Node2D

@export var mute: bool = false
@export var audio_stream_player: AudioStreamPlayer2D
@onready var ambient_player: AudioStreamPlayer2D = $AmbientPlayer

var surface_audio = [
	preload("res://assets/audio/sfx/waves.wav")
]

func _ready():
	if not mute:
		play_music()
		
func play_music():
	if not mute:
		audio_stream_player.play()

func _process(delta: float) -> void:
	if GameState.depth < 4 and !ambient_player.playing:
		ambient_player.stream = surface_audio[0]
		ambient_player.play()	
