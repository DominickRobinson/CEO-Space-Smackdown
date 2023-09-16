extends Weapon



func _ready():
	super._ready()
	
	if is_instance_valid($AnimationPlayer):
		$AnimationPlayer.play("wag")


func activate():
	self.disabled = false
	visible = true


func deactivate():
	self.disabled = true
	visible = false
