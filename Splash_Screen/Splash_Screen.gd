extends Control

signal started_menu_fade_in
signal faded_in
signal faded_out

onready var Mask = self.get_node("ColorRect")
onready var Splash_Texture = self.get_node("TextureRect")
onready var Fade_Timer = self.get_node("Fade_Timer")

var fade_speed = 0.5
var is_fading_in = false
var is_fading_out = false

func _process(delta):
	
	if is_fading_in:
		self.Mask.modulate.a -= self.fade_speed * delta
		if self.Mask.modulate.a < 0.0:
			self.Mask.modulate.a = 0.0
			is_fading_in = false
			self.emit_signal("faded_in")
	
	if is_fading_out:
		self.Splash_Texture.modulate.a -= self.fade_speed * delta
		if self.Splash_Texture.modulate.a < 0.0:
			self.Splash_Texture.modulate.a = 0.0
			is_fading_out = false
			self.visible = false
			self.emit_signal("faded_out")


func do_splash_screen():
	self.set_mouse_filter(MOUSE_FILTER_STOP)
	self.is_fading_in = true
	yield(self, "faded_in")
	self.Fade_Timer.wait_time = 3.0
	self.Fade_Timer.start()
	yield(self.Fade_Timer, "timeout")
	self.Fade_Timer.stop()
	self.is_fading_out = true
	self.emit_signal("started_menu_fade_in")
	yield(self, "faded_out")
	self.set_mouse_filter(MOUSE_FILTER_IGNORE)