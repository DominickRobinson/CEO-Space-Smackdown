class_name Gun
extends Weapon


@export var bullet_resource : Resource
@export var shoot_speed : float = 800

@onready var timer = $Timer

func activate():
	visible = true
	var b = bullet_resource.instantiate() as Bullet
	b.global_position = global_position
	b.global_rotation = global_rotation
	b.linear_velocity = Vector2(cos(global_rotation), sin(global_rotation)) * shoot_speed
	get_tree().current_scene.add_child(b)
	
	timer.start(1.0)
	await timer.timeout
	deactivate()


func deactivate():
	visible = false
