extends Node2D



@export var damage : float = 30
@export var impulse_length : float = 2000


@export var wheel_power : float = 1000
@export var wheel_damping : float = 0.8
@onready var wheel1 = $Wheel
@onready var wheel2 = $Wheel2

@onready var area = $Body/Area2D

var audio_player : AudioStreamPlayer

func _ready():
	wheel1.angular_damp = wheel_damping
	wheel2.angular_damp = wheel_damping
	
	audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	audio_player.stream = load("res://Assets/Sound/Items/CarVroom.mp3")
	
	var hurtbox = get_node("HurtBox")
	if is_instance_valid(hurtbox):
		hurtbox.damage = damage
		hurtbox.impulse_length = impulse_length


func _physics_process(delta):
	for b in area.get_overlapping_bodies():
		if b is Player:
			if b.is_moving_right:
				wheel1.apply_torque_impulse(wheel_power)
				wheel2.apply_torque_impulse(wheel_power)
			if b.is_moving_left:
				wheel1.apply_torque_impulse(-wheel_power)
				wheel2.apply_torque_impulse(-wheel_power)
			
			if b.is_moving_left or b.is_moving_right:
				if audio_player.playing == false:
					audio_player.play()
