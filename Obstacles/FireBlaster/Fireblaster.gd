extends Node2D

signal shake_requested

onready var Fire = self.get_node("Fire")
onready var Flash_Timer = self.get_node("Flash_Timer")
onready var Blast_Timer = self.get_node("Blast_Timer")
onready var Pulse_Timer = self.get_node("Pulse_Timer")
onready var Soul_Fire = preload("res://Obstacles/FireSpinner/Soulfire.tscn")
onready var Particle = preload("res://Particle_Effect/Particle.tscn")
onready var Explode_SFX = self.get_node("Explode_SFX")
onready var Fireblaster_Area = self.get_node("Area2D")

var is_falling = true
var fall_speed = 30.0
var is_rotating = true
var rotation_speed = 1.0
var blast_interval = 7.0
var is_blasting = false
var time_between_blasts = 5.0
var blast_direction = Vector2(0.0, 0.0)

var current_health = 15
var power = 1

var number_generator = RandomNumberGenerator.new()

func _ready():
	self.set_blast_time(self.time_between_blasts)
	self.Blast_Timer.start()
	self.Pulse_Timer.start()


func set_blast_time(time):
	self.time_between_blasts = time
	self.Blast_Timer.wait_time = time

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
	self.emit_signal("shake_requested", 0.5, 12.0)
	self.emit_particles()
	self.visible = false
	self.Fireblaster_Area.queue_free()
	self.Blast_Timer.stop()
	self.Pulse_Timer.stop()
	self.number_generator.randomize()
	var new_pitch = self.number_generator.randf_range(0.5, 1.5)
	self.Explode_SFX.pitch_scale = new_pitch
	self.Explode_SFX.play()
	


func _on_Blast_Timer_timeout():
	if not self.is_blasting:
		self.Fire.visible = true
		yield(get_tree().create_timer(1.0), "timeout")
		self.number_generator.randomize()
		self.blast_direction = Vector2(self.number_generator.randf_range(-1.0, 1.0), self.number_generator.randf_range(-1.0, 1.0)).normalized()
		self.is_blasting = true
		self.Blast_Timer.wait_time = self.blast_interval
		self.Blast_Timer.start()
	else:
		self.is_blasting = false
		self.Fire.visible = false
		self.Blast_Timer.wait_time = self.time_between_blasts
		self.Blast_Timer.start()

func blast():
	var New_Soul_Fire = Soul_Fire.instance()
	New_Soul_Fire.shoot_speed = 300.0
	New_Soul_Fire.is_shooting = true
	New_Soul_Fire.set_as_toplevel(true)
	New_Soul_Fire.global_position = self.global_position
	New_Soul_Fire.shoot_direction = self.blast_direction
	self.add_child(New_Soul_Fire)

func _on_Pulse_Timer_timeout():
	if self.is_blasting:
		self.blast()
		self.Pulse_Timer.start()


func emit_particles():
	var New_Particles = Particle.instance()
	New_Particles.set_as_toplevel(true)
	New_Particles.global_position = self.global_position
	New_Particles.lifetime = 1.2
	New_Particles.amount = 15
	New_Particles.scale = Vector2(1.0, 1.0) * 2.0
	self.get_parent().add_child(New_Particles)


func _on_Explode_SFX_finished():
	self.queue_free()
