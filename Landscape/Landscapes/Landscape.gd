extends Sprite

var is_moving = false
var speed = 0.0

func _process(delta):
	if not is_moving:
		return
	
	self.position.y += speed * delta
	
	if self.position.y > 1000.0:
		self.queue_free()
