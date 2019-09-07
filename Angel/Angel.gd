extends AnimatedSprite

signal dialog_requested
signal dialog_finished

onready var Dialog = self.get_node("Dialog_Box")
onready var AnimePlayer	 = self.get_node("AnimationPlayer")

var is_zoomed_in = false


func _on_Dialog_Nexus_dialog_authorized(actor, time_per_char, read_time, zoom, wait, msg):
	if actor == self.name:
		if zoom and not self.is_zoomed_in:
			self.zoom_in()
		Dialog.say(msg, time_per_char, read_time, wait)
	else:
		if self.is_zoomed_in:
			self.zoom_out()


func _on_Dialog_Box_dialog_finished():
	self.emit_signal("dialog_finished")


func zoom_in():
	self.is_zoomed_in = true
	self.AnimePlayer.play("Zoom")


func zoom_out():
	self.is_zoomed_in = false
	self.AnimePlayer.play_backwards("Zoom")

func _on_Dialog_Nexus_skipped_content():
	self.Dialog.skipped()
	if self.is_zoomed_in:
		self.is_zoomed_in = false
		self.AnimePlayer.play_backwards("Zoom")
