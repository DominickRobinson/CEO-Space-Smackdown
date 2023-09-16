class_name CharacterSelect
extends Node2D

@export var pointer_scene : PackedScene

var player_pointers = []

@onready var grid_container := $GridContainer as GridContainer
var grid_width : int
var grid_height : int
var grid_last_row_count : int


enum Direction {
	Left,
	Right,
	Up,
	Down,
}

func _ready() -> void:
	# init grid vars
	var num_chars := grid_container.get_child_count()
	grid_width = grid_container.columns
	grid_height = ceili(num_chars as float / grid_width as float)
	var count_mod_width := num_chars % grid_width
	grid_last_row_count = grid_width if count_mod_width == 0 else count_mod_width
	
	# Add initial player pointer (could remove later)
	create_select_pointer(Color.RED)
	create_select_pointer(Color.BLUE)
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left"):
		# figure out which player this is
		var player_index := 1
		var new_target := get_new_target_index(player_pointers[player_index].index, Direction.Left)
		player_pointers[player_index].index = new_target
		player_pointers[player_index].target = grid_container.get_child(new_target)
	if event.is_action_pressed("ui_right"):
		var player_index := 1
		var new_target := get_new_target_index(player_pointers[player_index].index, Direction.Right)
		player_pointers[player_index].index = new_target
		player_pointers[player_index].target = grid_container.get_child(new_target)
	if event.is_action_pressed("ui_up"):
		var player_index := 1
		var new_target := get_new_target_index(player_pointers[player_index].index, Direction.Up)
		player_pointers[player_index].index = new_target
		player_pointers[player_index].target = grid_container.get_child(new_target)
	if event.is_action_pressed("ui_down"):
		var player_index := 1
		var new_target := get_new_target_index(player_pointers[player_index].index, Direction.Down)
		player_pointers[player_index].index = new_target
		player_pointers[player_index].target = grid_container.get_child(new_target)
	
	if event.is_action_pressed("ui_left_alt"):
		var player_index = 0
		var new_target := get_new_target_index(player_pointers[player_index].index, Direction.Left)
		player_pointers[player_index].index = new_target
		player_pointers[player_index].target = grid_container.get_child(new_target)
	if event.is_action_pressed("ui_right_alt"):
		var player_index = 0
		var new_target := get_new_target_index(player_pointers[player_index].index, Direction.Right)
		player_pointers[player_index].index = new_target
		player_pointers[player_index].target = grid_container.get_child(new_target)
	if event.is_action_pressed("ui_up_alt"):
		var player_index = 0
		var new_target := get_new_target_index(player_pointers[player_index].index, Direction.Up)
		player_pointers[player_index].index = new_target
		player_pointers[player_index].target = grid_container.get_child(new_target)
	if event.is_action_pressed("ui_down_alt"):
		var player_index = 0
		var new_target := get_new_target_index(player_pointers[player_index].index, Direction.Down)
		player_pointers[player_index].index = new_target
		player_pointers[player_index].target = grid_container.get_child(new_target)
	

# Create a new pointer node, for when a player joins.
func create_select_pointer(color: Color = Color.WHITE) -> void:
	var pointer_instance := pointer_scene.instantiate() as CharacterSelectPointer
	player_pointers.append(pointer_instance)
	pointer_instance.modulate = color
	pointer_instance.target = grid_container.get_child(0) as CharacterSelectIcon
	add_child(pointer_instance)

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
			row = row - 1 if row != 0 else grid_height - 1
		Direction.Down:
			row = row + 1 if row + 1 < grid_height else 0
	
	return row * grid_width + col
