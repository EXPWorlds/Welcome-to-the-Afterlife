extends Sprite

var rotation_speed = PI

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta):
	self.position = self.get_global_mouse_position()
	self.rotate(self.rotation_speed * delta)