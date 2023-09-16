class_name HurtBox
extends Area2D

var damage : float = 0.0
var impulse_length : float = 0.0


func _on_body_entered(body):
	if not (body is Player) or body == get_parent().get_parent():
		return
	
	body = body as Player
	
	
	var angle = global_position.angle_to(body.global_position)
	var vec = Vector2(cos(angle), sin(angle)) * impulse_length
	body.take_damage(damage, vec)
