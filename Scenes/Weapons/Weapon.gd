class_name Weapon
extends Node2D


var active : bool = false

func _ready():
	deactivate()


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
