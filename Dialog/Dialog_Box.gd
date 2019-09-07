extends NinePatchRect

signal dialog_finished

onready var Text = self.get_node("Label")
onready var Typer_Timer = self.get_node("Typer_Timer")
onready var Read_Timer = self.get_node("Read_Timer")
onready var Space_Button = self.get_node("Space_Button")

var waiting = false

func _ready():
	self.visible = false
	Text.text = ""
	self.Space_Button.visible = false
	

func say(new_text, time_per_char, read_time, wait):
	self.Text.visible_characters = 0
	self.Text.text = new_text
	self.visible = true
	self.Typer_Timer.wait_time = time_per_char
	self.Read_Timer.wait_time = read_time
	self.waiting = wait
	Typer_Timer.start()


func _on_Typer_Timer_timeout():
	if self.Text.visible_characters < Text.get_total_character_count():
		self.Text.visible_characters += 1
		self.Typer_Timer.start()
	else:
		self.Typer_Timer.stop()
		if not self.waiting:
			self.Read_Timer.start()
		else:
			self.Space_Button.visible = true

func _unhandled_key_input(event):
	if not self.Typer_Timer.is_stopped() or not self.waiting:
		return
		
	if event is InputEventKey:
		if event.scancode == KEY_SPACE:
			self.continue_text()

func continue_text():
	self.Space_Button.visible = false
	self.waiting = false
	self.visible = false
	self.emit_signal("dialog_finished")


func _on_Read_Timer_timeout():
	self.Read_Timer.stop()
	self.visible = false
	self.emit_signal("dialog_finished")

func _on_Space_Button_pressed():
	self.continue_text()


func skipped():
	self.visible = false
	self.Space_Button.visible = false
	self.Typer_Timer.stop()
	self.Read_Timer.stop()
	self.waiting = false
