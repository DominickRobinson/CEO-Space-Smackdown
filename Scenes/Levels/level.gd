class_name Level
extends Node2D


@export var music : AudioStream

@export var gravity_multiplier : float = 1.0


@onready var p1_spawn = $PlayerOneSpawn
@onready var p2_spawn = $PlayerTwoSpawn

@onready var end_label = $PlayerWin/PanelContainer/CenterContainer/Label
@onready var end_screen = $PlayerWin
@onready var end_anim = $PlayerWin/AnimationPlayer

var game_over = false

func _ready():
	
	SoundManager.play_music(music)
	
	var p1 = LoadManager.player1_character.instantiate() as Player
	p1.player_number = 1
	p1.global_position = p1_spawn.global_position
	get_tree().current_scene.add_child(p1)
	
	var p2 = LoadManager.player2_character.instantiate() as Player
	p2.player_number = 2
	p2.global_position = p2_spawn.global_position
	get_tree().current_scene.add_child(p2)
	
	
	
	p1.die.connect(win1)
	p2.die.connect(win2)
	
	
	
	end_screen.hide()
	
	get_tree().current_scene.add_child(load("res://Scenes/UI/fight.tscn").instantiate())

func win1():
	if game_over: return
	game_over = true
	end_screen.show()
	end_anim.play("show")
	end_label.text = "Player 1 wins!"
	await get_tree().create_timer(3.0).timeout
	SceneManager.load_scene(load("res://Scenes/Menu/title.tscn"))


func win2():
	if game_over: return
	game_over = true
	end_screen.show()
	end_anim.play("show")
	end_label.text = "Player 2 wins!"
	await get_tree().create_timer(3.0).timeout
	SceneManager.load_scene(load("res://Scenes/Menu/title.tscn"))





