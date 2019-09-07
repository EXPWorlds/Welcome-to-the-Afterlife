extends Node2D

onready var Screen = self.get_parent()
onready var Shake_Timer = self.get_node("Duration")

export var duration = 0.2
export var amplitude = 16.0
export (float, EASE) var EASING = 1.0

func _ready():
	self.set_process(false)


func _process(delta):
	randomize()
	var dampening = ease(Shake_Timer.time_left / Shake_Timer.wait_time, EASING)
	self.Screen.offset = Vector2(rand_range(-self.amplitude, self.amplitude) * dampening,
								 rand_range(-self.amplitude, self.amplitude) * dampening)


func _on_Requested_shake(duration, amplitude):
	self.duration = duration
	self.amplitude = amplitude
	self.set_process(true)
	self.Shake_Timer.wait_time = self.duration
	self.Shake_Timer.start()


func _on_Duration_timeout():
	self.set_process(false)
	self.Shake_Timer.stop()
	self.Screen.offset = Vector2(0.0, 0.0)