extends CanvasLayer


@onready var name_label = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/Name



var player : Player
var percent_label : Label


func _ready():
	player = get_parent() as Player
	player.hit.connect(set_percent)
	
	if player.player_number == 1:
		percent_label = $MarginContainer/Player1Box/MarginContainer/VBoxContainer/Percent
		$MarginContainer/Player2Box.hide()
		percent_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	else:
		percent_label = $MarginContainer/Player2Box/MarginContainer/VBoxContainer/Percent as Label
		$MarginContainer/Player1Box.hide()
		percent_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	
	set_percent()


func set_percent():
	percent_label.text = str(player.damage) + "%"
