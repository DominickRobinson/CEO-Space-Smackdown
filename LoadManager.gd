extends Node

var player1_character : PackedScene
var player2_character : PackedScene

func set_characters(player1: PackedScene, player2: PackedScene):
	player1_character = player1
	player2_character = player2

func load_level(level: PackedScene):
	# do sometihng with characters
	pass
