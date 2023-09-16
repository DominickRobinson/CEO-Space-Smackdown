extends Node2D


@export var wheel_power : float = 500
@export var wheel_damping : float = 0.5
@onready var wheel1 = $Wheel
@onready var wheel2 = $Wheel2

@onready var area = $Body/Area2D


func _ready():
	wheel1.angular_damp = wheel_damping
	wheel2.angular_damp = wheel_damping


func _physics_process(delta):
	for b in area.get_overlapping_bodies():
		if b is Player:
			if b.is_moving_right:
#				wheel1.angular_velocity += wheel_power
#				wheel2.angular_velocity += wheel_power
				wheel1.apply_torque_impulse(wheel_power)
				wheel2.apply_torque_impulse(wheel_power)
			if b.is_moving_left:
#				wheel1.angular_velocity -= wheel_power
#				wheel2.angular_velocity -= wheel_power
				wheel1.apply_torque_impulse(-wheel_power)
				wheel2.apply_torque_impulse(-wheel_power)
