extends Weapon

@export var noise : AudioStream

var can_use = true


func activate():
	if not can_use:
		return
		
	self.monitoring = true
	visible = true
	
	#play sound here
	
	await get_tree().create_timer(2.0).timeout
	can_use = false
	deactivate()
	await get_tree().create_timer(3.0).timeout
	can_use = true

func deactivate():
	self.monitoring = false
	visible = false


func _on_body_entered(body):
	if not (body is RigidBody2D):
		return
	print(body.name)
	body = body as RigidBody2D
	var vec = Vector2(cos(global_rotation), sin(global_rotation)) * impulse_length
	body.apply_central_impulse(vec)
