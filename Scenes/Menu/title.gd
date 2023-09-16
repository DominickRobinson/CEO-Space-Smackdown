extends Control


@export var music : AudioStream


func _ready():
	SoundManager.play_music(music)
