extends Weapon



func activate():
	self.disabled = false
	visible = true


func deactivate():
	self.disabled = true
	visible = false
