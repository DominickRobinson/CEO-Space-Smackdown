extends Weapon



func _ready():
	pass




func _on_body_entered(body):
	if not (body is RigidBody2D):
		return
	
	body = body as RigidBody2D
	var vec = Vector2(cos(global_rotation), sin(global_rotation))
	body.apply_central_impulse(glob)
