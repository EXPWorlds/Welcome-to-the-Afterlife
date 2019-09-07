extends Node2D

signal gates_reached

var is_falling = true
var fall_speed = 50.0

func _process(delta):
	if is_falling:
		self.position.y += fall_speed * delta
		if self.position.y > 584:
			self.is_falling = false
			self.emit_signal("gates_reached")