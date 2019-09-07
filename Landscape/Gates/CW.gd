tool
extends Sprite

var rotation_speed = PI

func _process(delta):
	self.rotate(self.rotation_speed * delta)