extends Camera2D



var players = []

func _ready():
	players = get_tree().get_nodes_in_group("Players")


func _physics_process(delta):
	var sum = Vector2.ZERO
	
	for p in players:
		sum += p.global_position
	sum /= players.size()
	
	global_position = sum
