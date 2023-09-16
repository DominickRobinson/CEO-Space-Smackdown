extends Node

var player1_character : PackedScene = load("res://Scenes/Players/player.tscn")
var player2_character : PackedScene = load("res://Scenes/Players/player.tscn")
var level_resource : PackedScene

var character_select : PackedScene = load("res://Scenes/Menu/character_select_screen.tscn")
var level_select : PackedScene = load("res://Scenes/Menu/level_select_screen.tscn")


func set_characters(player1: PackedScene, player2: PackedScene):
	player1_character = player1
	player2_character = player2

func load_level_select():
	SceneManager.load_scene(level_select)

func load_character_select():
	SceneManager.load_scene(character_select)

func load_level(level: PackedScene):
	SceneManager.load_scene(level)
	# do sometihng with characters
	
