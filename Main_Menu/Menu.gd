extends Control

signal pressed_quit
signal pressed_play

signal faded_out

onready var Sigil_Spawner = self.get_node("Menu_Sigil_Spawer")
onready var Play_Button = self.get_node("Play_Button")
onready var Exit_Button = self.get_node("Exit_Button")

var is_fading_in = false
var is_fading_out = false
var fading_speed = 0.5

func _process(delta):
	if self.is_fading_in:
		self.fade_in()
	
	if self.is_fading_out:
		self.fade_out()

func fade_in():
	pass

func fade_out():
	self.modulate.a -= self.fading_speed * self.get_process_delta_time()
	if self.modulate.a < 0.0:
		self.visible = false
		self.is_fading_out = false
		self.Sigil_Spawner.spawner_on = false
		self.Sigil_Spawner.clear_sigils()
		self.emit_signal("faded_out")

func initialize_settings():
	self.Sigil_Spawner.spawner_on = true
	self.visible = true


func _on_Play_Button_mouse_entered():
	self.Play_Button.get_node("AnimationPlayer").play("Play_Button_Bigger")


func _on_Play_Button_mouse_exited():
	self.Play_Button.get_node("AnimationPlayer").play_backwards("Play_Button_Bigger")


func _on_Exit_Button_mouse_entered():
	self.Exit_Button.get_node("AnimationPlayer").play("Exit_Button_Bigger")


func _on_Exit_Button_mouse_exited():
	self.Exit_Button.get_node("AnimationPlayer").play_backwards("Exit_Button_Bigger")


func _on_Exit_Button_pressed():
	self.emit_signal("pressed_quit")


func _on_Play_Button_pressed():
	self.emit_signal("pressed_play")
