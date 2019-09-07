extends Node2D

onready var Shoot_Timer = self.get_node("Shoot_Timer")
onready var Flash_Timer = self.get_node("Flash_Timer")
onready var Soul_Fire = preload("res://Obstacles/FireSpinner/Soulfire.tscn")
onready var Particle = preload("res://Particle_Effect/Particle.tscn")

var shoot_time = 5.0
var current_health = 5
var number_generator = RandomNumberGenerator.new()
var is_shooting = true

func _ready():
	self.set_shoot_time(self.shoot_time)
	self.Shoot_Timer.start()


func set_shoot_time(time):
	self.shoot_time = time
	self.Shoot_Timer.wait_time = time


func _on_Shoot_Timer_timeout():
	if not self.is_shooting:
		return
	
	self.number_generator.randomize()
	var New_Soul_Fire = Soul_Fire.instance()
	New_Soul_Fire.shoot_speed = 100.0
	New_Soul_Fire.is_shooting = true
	New_Soul_Fire.set_as_toplevel(true)
	New_Soul_Fire.global_position = self.global_position
	var new_direction = Vector2(self.number_generator.randf_range(-1.0, 1.0), self.number_generator.randf_range(-1.0, 1.0)).normalized()
	New_Soul_Fire.shoot_direction = new_direction
	self.add_child(New_Soul_Fire)
	self.Shoot_Timer.start()

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
	self.emit_particles()
	self.queue_free()


func emit_particles():
	var New_Particles = Particle.instance()
	New_Particles.set_as_toplevel(true)
	New_Particles.global_position = self.global_position
	New_Particles.lifetime = 0.5
	New_Particles.amount = 12
	New_Particles.scale = Vector2(1.0, 1.0) * 0.5
	self.get_parent().add_child(New_Particles)