tool
extends Sprite

var rotation_speed = PI / 2.0

func _process(delta):
	self.rotate(self.rotation_speed * delta)