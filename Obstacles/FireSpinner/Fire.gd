extends Node2D

onready var Flash_Timer = self.get_node("Flash_Timer")
onready var Particle = preload("res://Particle_Effect/Particle.tscn")


var current_health = 1
var power = 1
var is_falling = false
var falling_speed = 150.0
var is_shooting = false
var shoot_direction = Vector2(1.0, 0.0)
var shoot_speed = 100.0

func _process(delta):
	if is_falling:
		self.position.y += self.falling_speed * self.get_process_delta_time()
		if self.position.y > 1200:
			self.queue_free()
	
	if is_shooting:
		self.global_position += self.shoot_direction * self.shoot_speed * delta
		if self.global_position.y > 1200.0 or self.global_position.y < -300.0 or self.global_position.x < -200.0 or self.global_position.x > 900:
			self.queue_free()

func _on_Area2D_area_entered(area):
	if area.name == "Bullet_Area":
		self.current_health -= area.get_parent().power
		if self.current_health <= 0:
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