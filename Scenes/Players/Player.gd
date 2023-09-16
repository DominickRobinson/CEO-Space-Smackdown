class_name Player
extends RigidBody2D

@export var player_number : int = 1

@export_group("Textures")
@export var texture_idle : Texture2D 
@export var texture_hit : Texture2D
@export var texture_attack1 : Texture2D
@export var texture_attack2 : Texture2D
@export var texture_taunt : Texture2D

@export_group("Sounds")
@export var sound_hit : AudioStream
@export var sound_attack1 : AudioStream
@export var sound_attack2 : AudioStream
@export var sound_taunt : AudioStream

@export_group("Weapons")
@export var weapon1 : Weapon
@export var weapon2 : Weapon

@export var ground_linear_velocity_boost = 20.0
@export var aerial_linear_velocity_boost = 10.0

@export var ground_angular_velocity_boost = 1
@export var aerial_angular_velocity_boost = .5

@export var ground_jump_boost = 600
@export var aerial_jump_boost = 800
@export var wall_jump_boost = 650
@export var wall_jump_angle_degrees = 45

@export var min_linear_velocity = 0
@export var min_angular_velocity = 0
@export var max_linear_velocity = 1000
@export var max_angular_velocity = 50


@onready var ground_raycast = $RayCast2Ds/GroundCast
@onready var left_raycast = $RayCast2Ds/LeftCast
@onready var right_raycast = $RayCast2Ds/RightCast
@onready var sprite = $Sprite2D
@onready var hitstun_timer = $HitStunTimer

signal hit
signal die

var is_moving_right = false
var is_moving_left = false
var is_jumping = false
var jumps = 2
var in_hitstun = false

var damage = 0

var player_stats_resource = preload("res://Scenes/UI/player_stats.tscn")


func _ready():
	set_sprite(texture_idle)
	add_child(player_stats_resource.instantiate())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	
	if is_hitstun_active():
		return
	
	check_commands()
	
	if player_number == 1:
		if Input.is_action_just_pressed("taunt"):
			SoundManager.play_sound(sound_taunt)
			set_sprite(texture_taunt)
		if Input.is_action_just_released("taunt"):
			set_sprite(texture_idle)
		
		
		if Input.is_action_just_pressed("attack1"):
			if is_instance_valid(weapon1):
				SoundManager.play_sound(sound_attack1)
				weapon1.toggle()
				if is_instance_valid(weapon2): weapon2.deactivate()
				set_sprite(texture_attack1)
				await get_tree().create_timer(1.0).timeout
				set_sprite(texture_idle)
		
		if Input.is_action_just_pressed("attack2"):
			if is_instance_valid(weapon2):
				SoundManager.play_sound(sound_attack2)				
				weapon2.toggle()
				if is_instance_valid(weapon1): weapon1.deactivate()
				set_sprite(texture_attack2)
				await get_tree().create_timer(1.0).timeout
				set_sprite(texture_idle)
	else:
		if Input.is_action_just_pressed("taunt_alt"):
			SoundManager.play_sound(sound_taunt)
			set_sprite(texture_taunt)
		if Input.is_action_just_released("taunt_alt"):
			set_sprite(texture_idle)
		
		
		if Input.is_action_just_pressed("attack1_alt"):
			if is_instance_valid(weapon1):
				SoundManager.play_sound(sound_attack1)
				weapon1.toggle()
				if is_instance_valid(weapon2): weapon2.deactivate()
				set_sprite(texture_attack1)
				await get_tree().create_timer(1.0).timeout
				set_sprite(texture_idle)
		
		if Input.is_action_just_pressed("attack2_alt"):
			if is_instance_valid(weapon2):
				SoundManager.play_sound(sound_attack2)				
				weapon2.toggle()
				if is_instance_valid(weapon1): weapon1.deactivate()
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
#				linear_velocity.y = -aerial_jump_boost
				jumps = 0
	else:
		if Input.is_action_pressed("move_right_alt"):
			if angular_velocity < 0: angular_velocity = min_angular_velocity
			angular_velocity += av_boost
			if linear_velocity.x < 0: 
				linear_velocity.x = -linear_velocity.x * 0.4
			else:
				linear_velocity.x += lv_boost
		#move left
		if Input.is_action_pressed("move_left_alt"):
			if angular_velocity > 0: angular_velocity = -min_angular_velocity
			angular_velocity -= av_boost
			if linear_velocity.x > 0: 
				linear_velocity.x = -linear_velocity.x * 0.4
			else:
				linear_velocity.x -= lv_boost
		#jump
		if Input.is_action_just_pressed("jump_alt"):
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
#				linear_velocity.y = -aerial_jump_boost
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
	if player_number == 1:
		is_moving_right = Input.is_action_pressed("move_right")
		is_moving_left = Input.is_action_pressed("move_left")
		is_jumping = Input.is_action_pressed("jump")
	else:
		is_moving_right = Input.is_action_pressed("move_right_alt")
		is_moving_left = Input.is_action_pressed("move_left_alt")
		is_jumping = Input.is_action_pressed("jump_alt")

func take_damage(amount:float, impulse:Vector2) -> void:
	
	damage += amount
	apply_central_impulse(impulse * damage / 100)
	
	set_sprite(texture_hit)
	hitstun_timer.start(1.0 * amount / 10)
	in_hitstun = true
	modulate = Color(0.5, 0.5, 0.5)
	hit.emit()
	SoundManager.play_sound(sound_hit)
	
	
	await hitstun_timer.timeout
	in_hitstun = false
	modulate = Color.WHITE
	set_sprite(texture_idle)
	



func is_hitstun_active() -> bool:
	return in_hitstun


func set_sprite(texture:Texture2D):
	sprite.texture = texture


func kill():
	die.emit()
	queue_free()
