class_name PlayerSelectDisplay
extends VBoxContainer

func set_character(current: CharacterSelectIcon) -> void:
	$Label.text = current.character_name
	$Image.texture = current.texture


func select_character(state: bool) -> void:
	$Image/ReadyOutline.visible = state
