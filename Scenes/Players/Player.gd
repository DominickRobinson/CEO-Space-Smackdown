class_name Player
extends RigidBody2D

@export var player_number : int = 1

@export var texture_idle : Texture2D 
@export var texture_hit : Texture2D
@export var texture_attack1 : Texture2D
@export var texture_attack2 : Texture2D
@export var texture_taunt : Texture2D


@export var weapon1 : Weapon
@export var weapon2 : Weapon

@export var ground_linear_velocity_boost = 20.0
@export var aerial_linear_velocity_boost = 10.0

@export var ground_angular_velocity_boost = 1
@export var aerial_angular_velocity_boost = .5

@export var ground_jump_boost = 600
@export var aerial_jump_boost = 800
@export var wall_jump_boost = 650
@export var wall_jump_angle_degrees = 7

@export var min_linear_velocity = 0
@export var min_angular_velocity = 0
@export var max_linear_velocity = 1000
@export var max_angular_velocity = 50


@onready var ground_raycast = $RayCast2Ds/GroundCast
@onready var left_raycast = $RayCast2Ds/LeftCast
@onready var right_raycast = $RayCast2Ds/RightCast
@onready var sprite = $Sprite2D
@onready var hitstun_timer = $HitStunTimer


var is_moving_right = false
var is_moving_left = false
var is_jumping = false
var jumps = 2

var damage = 0



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	
	if is_hitstun_active():
		return
	
	check_commands()
	
	if Input.is_action_just_pressed("taunt"):
		set_sprite(texture_taunt)
	if Input.is_action_just_released("taunt"):
		set_sprite(texture_idle)
	
	
	if Input.is_action_just_pressed("attack1"):
		if is_instance_valid(weapon1):
			weapon1.toggle()
			set_sprite(texture_attack1)
			await get_tree().create_timer(1.0).timeout
			set_sprite(texture_idle)
	
	if Input.is_action_just_pressed("attack2"):
		if is_instance_valid(weapon2):
			weapon2.toggle()
			set_sprite(texture_attack2)
			await get_tree().create_timer(1.0).timeout
			set_sprite(texture_idle)
	
	
	var lv_boost = aerial_linear_velocity_boost
	var av_boost = aerial_angular_velocity_boost
	if grounded():
		lv_boost = ground_linear_velocity_boost
		av_boost = ground_angular_velocity_boost
	
	
	
	#movement handler
	#move right
	
	if player_number == 1:
		if Input.is_action_pressed("move_right"):
			if angular_velocity < 0: angular_velocity = min_angular_velocity
			angular_velocity += av_boost
			if linear_velocity.x < 0: 
				linear_velocity.x = -linear_velocity.x * 0.4
			else:
				linear_velocity.x += lv_boost
		#move left
		if Input.is_action_pressed("move_left"):
			if angular_velocity > 0: angular_velocity = -min_angular_velocity
			angular_velocity -= av_boost
			if linear_velocity.x > 0: 
				linear_velocity.x = -linear_velocity.x * 0.4
			else:
				linear_velocity.x -= lv_boost
		#jump
		if Input.is_action_just_pressed("jump"):
			if grounded():
				jumps = 1
				linear_velocity.y -= ground_jump_boost
			elif on_left_wall():
				jumps = 1
				linear_velocity = Vector2.RIGHT.rotated(deg_to_rad(-wall_jump_angle_degrees)) * wall_jump_boost
			elif on_right_wall():
				jumps = 1
				linear_velocity = Vector2.LEFT.rotated(deg_to_rad(wall_jump_angle_degrees)) * wall_jump_boost
			elif jumps > 0:
				linear_velocity.y = -aerial_jump_boost
				jumps = 0
	
	clamp_linear_velocity(max_linear_velocity)
	clamp_angular_velocity(max_angular_velocity)




func clamp_linear_velocity(max_lv) -> Vector2:
	var curr_lv = linear_velocity.length()
	var new_lv = min(curr_lv, max_lv)
	linear_velocity = linear_velocity.normalized() * new_lv
	return linear_velocity

func clamp_angular_velocity(max_av) -> float:
	angular_velocity = min(angular_velocity, max_av)
	return angular_velocity


func grounded() -> bool:
	return ground_raycast.is_colliding()


func on_left_wall() -> bool:
	return left_raycast.is_colliding()


func on_right_wall() -> bool:
	return right_raycast.is_colliding()


func check_commands() -> void:
	is_moving_right = Input.is_action_pressed("move_right")
	is_moving_left = Input.is_action_pressed("move_left")
	is_jumping = Input.is_action_pressed("jump")


func take_damage(amount:float, impulse:Vector2) -> void:
	damage += amount
	apply_central_impulse(impulse * damage / 100)
	
	set_sprite(texture_hit)
	hitstun_timer.start(0.5)
	await hitstun_timer.timeout
	set_sprite(texture_idle)


func is_hitstun_active() -> bool:
	return not hitstun_timer.is_stopped()


func set_sprite(texture:Texture2D):
	sprite.texture = texture