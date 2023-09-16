extends Node

var player1_character : PackedScene
var player2_character : PackedScene
var level_resource : PackedScene

func set_characters(player1: PackedScene, player2: PackedScene):
	player1_character = player1
	player2_character = player2

func load_level(level_packed: PackedScene):
	SceneManager.load_scene(level_packed)
	
	var level = get_tree().current_scene
	level.player1_resource = player1_character
	level.player2_resource = player2_character
