extends Weapon



func _ready():
	pass



func activate():
	self.monitoring = true
	visible = true

func deactivate():
	self.monitoring = false
	visible = false


func _on_body_entered(body):
	if not (body is RigidBody2D):
		return
	
	body = body as RigidBody2D
	var vec = Vector2(cos(global_rotation), sin(global_rotation)) * impulse_length
	body.apply_central_impulse(vec)
