class_name Weapon
extends Node2D

@export var damage : float = 0.0
@export var impulse_length : float = 0.0


var active : bool = false

func _ready():
	deactivate()
	
	var hurtbox = get_node("HurtBox")
	if is_instance_valid(hurtbox):
		hurtbox.damage = damage
		hurtbox.impulse_length = impulse_length


func toggle():
	if not active:
		activate()
	else:
		deactivate()
	active = not active


func activate():
	pass


func deactivate():
	pass


func is_active() -> bool:
	return active
