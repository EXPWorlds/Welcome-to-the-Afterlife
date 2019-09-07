extends Node

signal black_sigil_acquired
signal white_sigil_acquired

var black_sigil_count = 0
var white_sigil_count = 0


func _on_Black_Sigil_Acquired():
	self.black_sigil_count += 1
	self.emit_signal("black_sigil_acquired", self.black_sigil_count)


func _on_White_Sigil_Acquired():
	self.white_sigil_count += 1
	self.emit_signal("white_sigil_acquired", self.white_sigil_count)


func clear_sigil_count():
	self.white_sigil_count = 0
	self.black_sigil_count = 0
	self.emit_signal("black_sigil_acquired", self.black_sigil_count)
	self.emit_signal("white_sigil_acquired", self.white_sigil_count)