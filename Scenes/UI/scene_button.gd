extends Button


@export var scene:PackedScene


func _on_pressed():
	SceneManager.load_scene(scene)
