extends CanvasLayer


@onready var anim = $AnimationPlayer


func load_scene(packed_scene:PackedScene):
	anim.play("fade_out")
	await anim.animation_changed
	get_tree().change_scene_to_packed(packed_scene)
	await get_tree().tree_changed
	anim.play("fade_in")
