extends RigidBody2D



func _physics_process(delta):
	var vec = Vector2(cos(rotation), sin(rotation)) * 500
	linear_velocity = vec
