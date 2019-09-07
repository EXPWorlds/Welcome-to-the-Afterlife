extends Node2D

var rotate_speed = 0.0

func _process(delta):
	self.rotate(self.rotate_speed * delta)