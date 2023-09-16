class_name CharacterSelectPointer
extends Control

var target : CharacterSelectIcon:
	set(val):
		$TextureRect.global_position = val.global_position
		target = val
	get:
		return target 

var index := 0
var selected := false

func toggle_selected() -> void:
	selected = not selected
	if selected:
		SoundManager.play_sound(target.select_sound)
		$TextureRect.scale = Vector2(0.8,0.8)
	else:
		$TextureRect.scale = Vector2(1,1)
