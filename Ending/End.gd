extends Control

signal faded_in
signal faded_out
signal started_fading_out

onready var Ending_Texture = self.get_node("TextureRect")
onready var Fade_Timer = self.get_node("Fade_Timer")

onready var Game_Over_Texture = load("res://Ending/game_over.png")
onready var End_Tie_Texture = load("res://Ending/end_tie.png")
onready var End_Black_Texture = load("res://Ending/end_black.png")
onready var End_White_Texture = load("res://Ending/end_white.png")
onready var End_Win_Texture = load("res://Ending/end_win.png")

var fade_speed = 0.5
var is_fading_in = false
var is_fading_out = false

func _process(delta):
	
	if is_fading_in:
		self.Ending_Texture.modulate.a += self.fade_speed * delta
		if self.Ending_Texture.modulate.a > 1.0:
			self.Ending_Texture.modulate.a = 1.0
			is_fading_in = false
			self.Fade_Timer.start()
			self.mouse_filter = Control.MOUSE_FILTER_STOP
			self.emit_signal("faded_in")
	
	if is_fading_out:
		self.Ending_Texture.modulate.a -= self.fade_speed * delta
		if self.Ending_Texture.modulate.a < 0.0:
			self.Ending_Texture.modulate.a = 0.0
			is_fading_out = false
			self.mouse_filter = Control.MOUSE_FILTER_IGNORE
			self.emit_signal("faded_out")


func set_wait_time(time):
	self.Fade_Timer.wait_time = time

func _on_Fade_Timer_timeout():
	self.is_fading_out = true
	self.emit_signal("started_fading_out")
	self.Fade_Timer.stop()

func load_texture(texture):
	match texture:
		"game over":
			self.Ending_Texture.texture = self.Game_Over_Texture
			self.Ending_Texture.modulate.a = 0.0
		"end_tie":
			self.Ending_Texture.texture = self.End_Tie_Texture
			self.Ending_Texture.modulate.a = 0.0
		"end_black":
			self.Ending_Texture.texture = self.End_Black_Texture
			self.Ending_Texture.modulate.a = 0.0
		"end_white":
			self.Ending_Texture.texture = self.End_White_Texture
			self.Ending_Texture.modulate.a = 0.0
		"end_win":
			self.Ending_Texture.texture = self.End_Win_Texture
			self.Ending_Texture.modulate.a = 0.0