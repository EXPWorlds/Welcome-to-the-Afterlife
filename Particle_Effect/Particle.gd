extends Particles2D

onready var Kill_Timer = self.get_node("Timer")

func _ready():
	self.emitting = true
	self.Kill_Timer.start()

func _on_Timer_timeout():
	self.queue_free()
