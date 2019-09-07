extends Node2D

onready var Particle = preload("res://Particle_Effect/Particle.tscn")
onready var Fire_SFX = self.get_node("Fire_SFX")
onready var Hit_SFX = self.get_node("Hit_SFX")
onready var Bullet_Area = self.get_node("Bullet_Area")

var number_generator = RandomNumberGenerator.new()

var target_coords : Vector2
var speed = 0.0
var direction
var power = 1.0

var enroute = false

func _ready():
	self.set_as_toplevel(true)
	self.direction = (self.get_global_mouse_position() - self.global_position).normalized()
	self.number_generator.randomize()
	var new_pitch = self.number_generator.randf_range(0.8, 1.2)
	self.Fire_SFX.pitch_scale = new_pitch
	self.Fire_SFX.play()

func _process(delta):
	if enroute == false:
		return
	

	self.global_position += direction *  speed * delta
	

func _on_Area2D_area_entered(area):
	if area.name == "Player_Area":
		return
	
	if area.name == "Bullet_Area":
		return
	
	if area.name == "Player":
		return
	
	if not area.get_groups().has("Wall"):
		self.emit_particles()
		self.clear_self()
	else:
		self.queue_free()

func emit_particles():
	var New_Particles = Particle.instance()
	New_Particles.set_as_toplevel(true)
	New_Particles.global_position = self.global_position
	New_Particles.lifetime = 0.3
	New_Particles.amount = 6
	New_Particles.scale = Vector2(1.0, 1.0) * 0.3
	self.get_parent().add_child(New_Particles)


func clear_self():
	self.visible = false
	self.Bullet_Area.queue_free()
	self.number_generator.randomize()
	var new_pitch = self.number_generator.randf_range(0.7, 1.0)
	self.Hit_SFX.pitch_scale = new_pitch
	self.Hit_SFX.play()

func _on_Hit_SFX_finished():
	self.queue_free()
