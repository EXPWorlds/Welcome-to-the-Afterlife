extends Node2D

signal shake_requested

onready var Flash_Timer = self.get_node("Flash_Timer")
onready var Particle = preload("res://Particle_Effect/Particle.tscn")
onready var Explode_SFX = self.get_node("Explode_SFX")
onready var Firespitter_Area = self.get_node("Area2D")

var is_falling = true
var fall_speed = 20.0
var is_rotating = true
var rotation_speed = -1.0

var current_health = 15
var power = 1

var number_generator = RandomNumberGenerator.new()

func _process(delta):
	if is_rotating:
		self.rotate(self.rotation_speed * delta)
	
	if is_falling:
		self.position.y += self.fall_speed * delta
		if self.position.y > 1200:
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
	self.emit_signal("shake_requested", 0.5, 10.0)
	self.emit_particles()
	self.visible = false
	self.Firespitter_Area.queue_free()
	if self.has_node("FireShooter"):
		self.get_node("FireShooter").queue_free()
	if self.has_node("FireShooter2"):
		self.get_node("FireShooter2").queue_free()
	if self.has_node("FireShooter3"):
		self.get_node("FireShooter3").queue_free()
	if self.get_node("FireShooter4"):
		self.get_node("FireShooter4").queue_free()
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
	New_Particles.scale = Vector2(1.0, 1.0) * 1.5
	self.get_parent().add_child(New_Particles)

func _on_Explode_SFX_finished():
	self.queue_free()
