class_name Bullet
extends RigidBody2D


@export var free_on_impact : bool = true

@export var damage : float = 5.0
@export var impulse_length : float = 700.0


func _ready():
	body_entered.connect(_on_hit)
	contact_monitor = true
	max_contacts_reported = 2


func _on_hit(body : Node):
	if body is Player:
		if linear_velocity.length() > 10:
			var p = body as Player
			var vec = Vector2(cos(global_rotation), sin(global_rotation)) * impulse_length
			p.take_damage(damage, vec)
	if free_on_impact:
		queue_free()
	else:
		await get_tree().create_timer(5.0).timeout
		queue_free()
