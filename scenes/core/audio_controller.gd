extends Node2D

@export var mute: bool = false
@export var audio_stream_player: AudioStreamPlayer2D
func _ready():
	if not mute:
		play_music()
		
func play_music():
	if not mute:
		audio_stream_player.play()
