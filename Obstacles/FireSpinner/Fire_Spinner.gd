extends Node2D

signal shake_requested

onready var Flash_Timer = self.get_node("Flash_Timer")
onready var Explode_SFX = self.get_node("Explode_SFX")
onready var Firespinner_Area = self.get_node("Area2D")
onready var Spinner = self.get_node("Spinner")
onready var Particle = preload("res://Particle_Effect/Particle.tscn")

var is_moving = false
var move_speed = 30.0
var current_health = 10
var power = 1

var number_generator = RandomNumberGenerator.new()


var spinner_speed = -0.5

func _process(delta):
	self.Spinner.rotate(spinner_speed * delta)
	
	if not self.is_moving:
		return
	
	self.position.y += self.move_speed * delta
	
	if self.position.y > 1300:
		self.queue_free()

func _on_Area2D_area_entered(area):
	if area.name == "Bullet_Area":
		self.current_health -= area.get_parent().power
		if self.current_health < 0:
			self.die()
		self.do_hit_flash()


func do_hit_flash():
	self.modulate = Color(1.0, 0.0, 0.0, 1.0)
	self.Flash_Timer.start()
	yield(self.Flash_Timer, "timeout")
	self.Flash_Timer.stop()
	self.modulate = Color(1.0, 1.0, 1.0, 1.0)


func die():
	self.emit_signal("shake_requested", 0.5, 8.0)
	self.emit_particles()
	self.visible = false
	self.Firespinner_Area.queue_free()
	self.set_process(false)
	self.Spinner.queue_free()
	self.number_generator.randomize()
	var new_pitch = self.number_generator.randf_range(0.5, 1.5)
	self.Explode_SFX.pitch_scale = new_pitch
	self.Explode_SFX.play()

func emit_particles():
	var New_Particles = Particle.instance()
	New_Particles.set_as_toplevel(true)
	New_Particles.global_position = self.global_position
	New_Particles.lifetime = 1.0
	New_Particles.amount = 15
	New_Particles.scale = Vector2(1.0, 1.0) * 1.0
	self.get_parent().add_child(New_Particles)

func _on_Explode_SFX_finished():
	self.queue_free()
