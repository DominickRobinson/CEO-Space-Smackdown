class_name PlayerSelectDisplay
extends VBoxContainer

@export var player_number : int = 1


func _ready():
	if player_number != 0:
		$Label2.text = "Player " + str(player_number)
	else:
		$Label2.hide()

func set_character(current: CharacterSelectIcon) -> void:
	$Label.text = current.character_name
	$Image.texture = current.texture


func select_character(state: bool) -> void:
	$Image/ReadyOutline.visible = state
