extends Button


var scene:PackedScene = preload("res://Scenes/Menu/title.tscn")


func _on_pressed():
	SceneManager.load_scene(scene)
