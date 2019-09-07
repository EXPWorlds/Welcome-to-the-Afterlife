extends Sprite

var spin_speed = PI

func _process(delta):
	self.rotate(spin_speed * delta)