extends Control

signal faded_in
signal faded_out

var fade_speed = 0.5
var is_fading_in = false
var is_fading_out = false

func _process(delta):
	
	if is_fading_in:
		self.modulate.a += self.fade_speed * delta
		if self.modulate.a > 1.0:
			self.modulate.a = 1.0
			is_fading_in = false
			self.emit_signal("faded_in")
	
	if is_fading_out:
		self.modulate.a -= self.fade_speed * delta
		if self.modulate.a < 0.0:
			self.modulate.a = 0.0
			is_fading_out = false
			self.emit_signal("faded_out")