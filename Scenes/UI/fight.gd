extends CanvasLayer



func _ready():
	$AnimationPlayer.play("fight")
	
	await $AnimationPlayer.animation_finished
	
	queue_free()
