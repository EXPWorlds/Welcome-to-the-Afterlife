extends Timer

signal ticked

var current_game_time = 0

func _on_Game_Timer_timeout():
	self.current_game_time += 1
	self.emit_signal("ticked", current_game_time)


func reset_game_time():
	self.current_game_time = 0