extends Weapon



var hurtbox : HurtBox


func _ready():
	super._ready()
	
	if is_instance_valid($AnimationPlayer):
		$AnimationPlayer.play("wag")
	
	hurtbox = get_node("HurtBox")
	if is_instance_valid(hurtbox):
		hurtbox.damage = damage
		hurtbox.impulse_length = impulse_length

func activate():
	self.disabled = false
	visible = true


func deactivate():
	self.disabled = true
	visible = false
