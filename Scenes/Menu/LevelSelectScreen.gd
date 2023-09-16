class_name LevelSelect
extends Control

@export var pointer_scene : PackedScene

var player_pointer : CharacterSelectPointer
# this is bool of whether they've "locked in" a choice
var selected = false

@onready var icon_grid := $IconGrid as GridContainer
var grid_width : int
var grid_height : int
var grid_last_row_count : int

@onready var display: VBoxContainer = $Display

@onready var fight_button: Control = $FightButton

enum Direction {
	Left,
	Right,
	Up,
	Down,
}

func _ready() -> void:
	# init grid vars
	var num_chars := icon_grid.get_child_count()
	grid_width = icon_grid.columns
	grid_height = ceili(num_chars as float / grid_width as float)
	var count_mod_width := num_chars % grid_width
	grid_last_row_count = grid_width if count_mod_width == 0 else count_mod_width
	
	# Add initial player pointer (could remove later)
	create_select_pointer(Color.WHITE)
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("move_left") or event.is_action_pressed("move_left_alt"):
		if selected:
			return
		var new_target := get_new_target_index(player_pointer.index, Direction.Left)
		player_pointer.index = new_target
		player_pointer.target = icon_grid.get_child(new_target)
		display.set_character(icon_grid.get_child(new_target))
	if event.is_action_pressed("move_right") or event.is_action_pressed("move_right_alt"):
		if selected:
			return
		var new_target := get_new_target_index(player_pointer.index, Direction.Right)
		player_pointer.index = new_target
		player_pointer.target = icon_grid.get_child(new_target)
		display.set_character(icon_grid.get_child(new_target))
	if event.is_action_pressed("jump") or event.is_action_pressed("jump_alt"):
		if selected:
			return
		var new_target := get_new_target_index(player_pointer.index, Direction.Up)
		player_pointer.index = new_target
		player_pointer.target = icon_grid.get_child(new_target)
		display.set_character(icon_grid.get_child(new_target))
	if event.is_action_pressed("taunt") or event.is_action_pressed("taunt_alt"):
		if selected:
			return
		var new_target := get_new_target_index(player_pointer.index, Direction.Down)
		player_pointer.index = new_target
		player_pointer.target = icon_grid.get_child(new_target)
		display.set_character(icon_grid.get_child(new_target))
	if event.is_action_pressed("attack1") or event.is_action_pressed("attack2") or event.is_action_pressed("attack1_alt") or event.is_action_pressed("attack2_alt"):
		player_pointer.toggle_selected()
		selected = not selected
		display.select_character(selected)
		update_selection_status()
	
	# PRESS ENTER HERE
	if event.is_action_pressed("start") and selected:
		LoadManager.load_level(player_pointer.target.character_scene)

# Create a new pointer node, for when a player joins.
func create_select_pointer(color: Color = Color.WHITE) -> void:
	var pointer_instance := pointer_scene.instantiate() as CharacterSelectPointer
	player_pointer = pointer_instance
	pointer_instance.modulate = color
	add_child(pointer_instance)
	pointer_instance.target = icon_grid.get_child(0) as CharacterSelectIcon
	selected = false
	display.set_character(icon_grid.get_child(0))

func update_selection_status() -> void:
	# set map LoadManager.set_characters(player_pointers[0].target.character_scene, player_pointers[1].target.character_scene)
	fight_button.visible = selected

func get_new_target_index(current: int, direction: Direction) -> int:
	var row : int = current / grid_width
	var col : int = current % grid_width
	
	match direction:
		Direction.Left: 
			if col != 0:
				col -= 1
			else:
				col = grid_width - 1 if row + 1 < grid_height else grid_last_row_count - 1
		Direction.Right:
			if row + 1 == grid_height:
				if col != grid_last_row_count - 1:
					col += 1
				else:
					col = 0
			else:
				col = 0 if col == grid_width - 1 else col + 1
		Direction.Up:
			if row == 0:
				row = grid_height - 1 if grid_last_row_count-1 >= col else (grid_height - 2 if grid_height > 1 else 0)
			else:
				row -= 1
		Direction.Down:
			if row == grid_height - 2:
				row = grid_height - 1 if grid_last_row_count-1 >= col else 0
			else:
				row = row + 1 if row < grid_height - 1 else 0
	
	return row * grid_width + col
