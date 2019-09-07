extends Sprite

var is_falling = false
var fall_speed = 30.0

func _process(delta):
	if self.is_falling:
		self.position.y += self.fall_speed * delta
		if self.position.y > 1200:
			self.queue_free()