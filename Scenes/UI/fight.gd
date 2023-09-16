extends CanvasLayer



func _ready():
	$AnimationPlayer.play("fight")
	
#	SoundManager.play_sound()
	
	
	await $AnimationPlayer.animation_finished
	
	queue_free()
