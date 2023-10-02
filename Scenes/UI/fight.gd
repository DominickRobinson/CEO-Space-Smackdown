extends CanvasLayer



func _ready():
	$AnimationPlayer.play("fight")
	
	SoundManager.play_sound(load("res://Assets/Sound/CharacterSelect/Fight2.mp3"))
	
	
	await $AnimationPlayer.animation_finished
	
	queue_free()
