extends Node2D

signal boss_defeated
signal shake_requested

onready var Flash_Timer = self.get_node("Flash_Timer")
onready var Blast_Timer = self.get_node("Blast_Timer")
onready var Pulse_Timer = self.get_node("Pulse_Timer")
onready var Spawn_Timer = self.get_node("Spawn_Timer")
onready var Bone_Root = self.get_node("Bone_Root")
onready var Eye_Sprite = self.get_node("Eye_Sprite")
onready var Boss_Bone = preload("res://Obstacles/Boss/Boss_Bone/Boss_Bone.tscn")
onready var Soul_Fire = preload("res://Obstacles/FireSpinner/Soulfire.tscn")
onready var Fireshooter = preload("res://Obstacles/FireShooter/FireShooter.tscn")
onready var Fire = self.get_node("Fire")
onready var Fireshooter_Inside_Root = self.get_node("Fireshooter_Inside_Root")
onready var FireSpitter = preload("res://Obstacles/FireSpitter/FireSpitter.tscn")
onready var FireBlaster = preload("res://Obstacles/FireBlaster/Fireblaster.tscn")
onready var FireSpinner = preload("res://Obstacles/FireSpinner/Fire_Spinner.tscn")
onready var Fireshooter_Outside_Root = self.get_node("Fireshooter_Outside_Root")
onready var Particle = preload("res://Particle_Effect/Particle.tscn")
onready var Explode_SFX = self.get_node("Explode_SFX")
onready var Boss_Area = self.get_node("Area2D")

var is_falling = true
var fall_speed = 50.0

var current_health = 100
var power = 1
var black_sigil_count = 0
var white_sigil_count = 0
var eye_rotate_speed = 0.5
var bone_rotate_speed = -PI
var fireshooter_outside_rotation_speed = PI

var blast_interval = 7.0
var is_blasting = false
var is_fireshooters_shooting = false
var time_between_blasts = 5.0
var blast_direction = Vector2(0.0, 0.0)


var base_location = Vector2(0.0, 0.0)
var picked_location = Vector2(0.0, 0.0)
var wander_speed = 20.0

var number_generator = RandomNumberGenerator.new()

func _ready():
	self.current_health += (self.black_sigil_count + self.white_sigil_count) * 5
	for bone in self.Bone_Root.get_children():
		bone.current_health += (self.black_sigil_count ) * 3
	self.set_blast_time(self.time_between_blasts)
	self.Blast_Timer.start()
	self.Pulse_Timer.start()
	self.Spawn_Timer.start()
	
	for inside_fire_shooter in range(10 + self.white_sigil_count):
		var New_Fireshooter = self.Fireshooter.instance()
		New_Fireshooter.show_behind_parent = true
		New_Fireshooter.is_shooting = false
		self.Fireshooter_Inside_Root.add_child(New_Fireshooter)
	for shooter in self.Fireshooter_Outside_Root.get_children():
				shooter.get_node("FireShooter").is_shooting = false


func set_blast_time(time):
	self.time_between_blasts = time
	self.Blast_Timer.wait_time = time


func _process(delta):
	
	self.Eye_Sprite.rotate(self.eye_rotate_speed * delta)
	self.Bone_Root.rotate(self.bone_rotate_speed * delta)
	self.Fireshooter_Outside_Root.rotate(self.fireshooter_outside_rotation_speed * delta)
	
	
	if self.is_falling:
		self.position.y += self.fall_speed * delta
		if self.position.y > 584:
			self.is_falling = false
			self.base_location = self.position
			self.number_generator.randomize()
			var new_position = Vector2(self.number_generator.randi_range(-200, 200), self.number_generator.randi_range(-200, 200))
			self.picked_location = self.base_location + new_position 
	else:
		var direction = (self.picked_location - self.position).normalized()
		self.position += direction * self.wander_speed * delta
		if (self.picked_location - self.position).length() < 5.0:
			var new_position = Vector2(self.number_generator.randi_range(-200, 100), self.number_generator.randi_range(-200, 100))
			self.picked_location = self.base_location + new_position
		if not self.is_fireshooters_shooting:
			self.is_fireshooters_shooting = true
			for shooter in self.Fireshooter_Inside_Root.get_children():
				shooter.is_shooting = true
			var outside_fireshooters = self.Fireshooter_Outside_Root.get_children()
			if not outside_fireshooters.empty():
				for shooter in outside_fireshooters:
					var childern = shooter.get_node("FireShooter")
					if not childern == null:
						shooter.get_node("FireShooter").is_shooting = true


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
	self.emit_signal("shake_requested", 1.0, 32.0)
	self.emit_signal("boss_defeated")
	self.emit_particles()
	self.visible = false
	self.set_process(false)
	self.Bone_Root.queue_free()
	self.Boss_Area.queue_free()
	self.Pulse_Timer.stop()
	self.Blast_Timer.stop()
	self.Spawn_Timer.stop()
	self.Fireshooter_Inside_Root.queue_free()
	self.Fireshooter_Outside_Root.queue_free()
	self.number_generator.randomize()
	self.Explode_SFX.play()


func _on_shake_requested(duration, amplitude):
	self.emit_signal("shake_requested", duration, amplitude)


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
	if self.is_falling:
		return
	
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

func _on_Spawn_Timer_timeout():
	if self.is_falling:
		return

	var what_to_spawn = self.number_generator.randi_range(0,2)
	match what_to_spawn:
		0:
			self.spawn_firespinner()
		1:
			self.spawn_fireblaster()
		2:
			self.spawn_fireblaster()
	self.Spawn_Timer.start()

func spawn_firespinner():
	var New_Firespinner = FireSpinner.instance()
	New_Firespinner.set_as_toplevel(true)
	New_Firespinner.global_position = self.global_position
	self.add_child(New_Firespinner)
	New_Firespinner.connect("shake_requested", self, "_on_shake_requested")
	New_Firespinner.is_moving = true


func spawn_firespitter():
	var New_Firespitter = FireSpitter.instance()
	New_Firespitter.set_as_toplevel(true)
	New_Firespitter.global_position = self.global_position
	self.add_child(New_Firespitter)
	New_Firespitter.connect("shake_requested", self, "_on_shake_requested")
	New_Firespitter.is_falling = true


func spawn_fireblaster():
	var New_Fireblaster = FireBlaster.instance()
	New_Fireblaster.set_as_toplevel(true)
	New_Fireblaster.global_position = self.global_position
	self.add_child(New_Fireblaster)
	New_Fireblaster.connect("shake_requested", self, "_on_shake_requested")
	New_Fireblaster.is_falling = true

func emit_particles():
	var New_Particles = Particle.instance()
	New_Particles.set_as_toplevel(true)
	New_Particles.global_position = self.global_position
	New_Particles.lifetime = 3.0
	New_Particles.amount = 100
	New_Particles.scale = Vector2(1.0, 1.0) * 3.0
	self.get_parent().add_child(New_Particles)

func _on_Explode_SFX_finished():
	self.queue_free()