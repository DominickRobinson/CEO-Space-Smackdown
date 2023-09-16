class_name CharacterSelect
extends Control

@export var pointer_scene : PackedScene

# these are the two boxy select pointer things
var player_pointers = []
# and this is bools of whether they've "locked in" a choice
var player_pointers_selected = []

@onready var icon_grid := $IconGrid as GridContainer
var grid_width : int
var grid_height : int
var grid_last_row_count : int

@onready var player_1: VBoxContainer = $BottomBar/Player1
@onready var player_2: VBoxContainer = $BottomBar/Player2

var player_select_displays = []
@onready var fight_button: Control = $FightButton
var all_ready = false

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
	
	player_select_displays.append(player_1)
	player_select_displays.append(player_2)
	
	# Add initial player pointer (could remove later)
	create_select_pointer(Color.RED, 0)
	create_select_pointer(Color.BLUE, 1)
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("move_left"):
		# figure out which player this is
		var player_index := 0
		if player_pointers_selected[player_index]:
			return
		var new_target := get_new_target_index(player_pointers[player_index].index, Direction.Left)
		player_pointers[player_index].index = new_target
		player_pointers[player_index].target = icon_grid.get_child(new_target)
		player_select_displays[player_index].set_character(icon_grid.get_child(new_target))
	if event.is_action_pressed("move_right"):
		var player_index := 0
		if player_pointers_selected[player_index]:
			return
		var new_target := get_new_target_index(player_pointers[player_index].index, Direction.Right)
		player_pointers[player_index].index = new_target
		player_pointers[player_index].target = icon_grid.get_child(new_target)
		player_select_displays[player_index].set_character(icon_grid.get_child(new_target))
	if event.is_action_pressed("jump"):
		var player_index := 0
		if player_pointers_selected[player_index]:
			return
		var new_target := get_new_target_index(player_pointers[player_index].index, Direction.Up)
		player_pointers[player_index].index = new_target
		player_pointers[player_index].target = icon_grid.get_child(new_target)
		player_select_displays[player_index].set_character(icon_grid.get_child(new_target))
	if event.is_action_pressed("taunt"):
		var player_index := 0
		if player_pointers_selected[player_index]:
			return
		var new_target := get_new_target_index(player_pointers[player_index].index, Direction.Down)
		player_pointers[player_index].index = new_target
		player_pointers[player_index].target = icon_grid.get_child(new_target)
		player_select_displays[player_index].set_character(icon_grid.get_child(new_target))
	if event.is_action_pressed("attack1") or event.is_action_pressed("attack2"):
		var player_index := 0
		player_pointers[player_index].toggle_selected()
		player_pointers_selected[player_index] = not player_pointers_selected[player_index]
		player_select_displays[player_index].select_character(player_pointers_selected[player_index])
		update_selection_status()
	
	if event.is_action_pressed("move_left_alt"):
		var player_index = 1
		if player_pointers_selected[player_index]:
			return
		var new_target := get_new_target_index(player_pointers[player_index].index, Direction.Left)
		player_pointers[player_index].index = new_target
		player_pointers[player_index].target = icon_grid.get_child(new_target)
		player_select_displays[player_index].set_character(icon_grid.get_child(new_target))
	if event.is_action_pressed("move_right_alt"):
		var player_index = 1
		if player_pointers_selected[player_index]:
			return
		var new_target := get_new_target_index(player_pointers[player_index].index, Direction.Right)
		player_pointers[player_index].index = new_target
		player_pointers[player_index].target = icon_grid.get_child(new_target)
		player_select_displays[player_index].set_character(icon_grid.get_child(new_target))
	if event.is_action_pressed("jump_alt"):
		var player_index = 1
		if player_pointers_selected[player_index]:
			return
		var new_target := get_new_target_index(player_pointers[player_index].index, Direction.Up)
		player_pointers[player_index].index = new_target
		player_pointers[player_index].target = icon_grid.get_child(new_target)
		player_select_displays[player_index].set_character(icon_grid.get_child(new_target))
	if event.is_action_pressed("taunt_alt"):
		var player_index = 1
		if player_pointers_selected[player_index]:
			return
		var new_target := get_new_target_index(player_pointers[player_index].index, Direction.Down)
		player_pointers[player_index].index = new_target
		player_pointers[player_index].target = icon_grid.get_child(new_target)
		player_select_displays[player_index].set_character(icon_grid.get_child(new_target))
	if event.is_action_pressed("attack1_alt") or event.is_action_pressed("attack2_alt"):
		var player_index := 1
		player_pointers[player_index].toggle_selected()
		player_pointers_selected[player_index] = not player_pointers_selected[player_index]
		player_select_displays[player_index].select_character(player_pointers_selected[player_index])
		update_selection_status()
	
	# PRESS ENTER HERE
	if event.is_action_pressed("start") and all_ready:
		LoadManager.load_level_select()

# Create a new pointer node, for when a player joins.
func create_select_pointer(color: Color = Color.WHITE, ind: int = -1) -> void:
	var pointer_instance := pointer_scene.instantiate() as CharacterSelectPointer
	player_pointers.append(pointer_instance)
	pointer_instance.modulate = color
	add_child(pointer_instance)
	pointer_instance.target = icon_grid.get_child(ind) as CharacterSelectIcon
	player_pointers_selected.append(false)
	player_select_displays[ind].set_character(icon_grid.get_child(ind))

func update_selection_status() -> void:
	LoadManager.set_characters(player_pointers[0].target.character_scene, player_pointers[1].target.character_scene)
	for state in player_pointers_selected:
		if not state:
			# not ready
			fight_button.visible = false
			all_ready = false
			return
	# all selected
	fight_button.visible = true
	all_ready = true

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
