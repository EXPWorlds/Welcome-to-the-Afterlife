extends KinematicBody2D

signal shake_requested
signal entered_stage
signal player_died

onready var Player_Sprite = self.get_node("AnimatedSprite")
onready var Damage_SFX = self.get_node("Damage_SFX")
onready var Death_SFX = self.get_node("Death_SFX")
onready var Blaster = self.get_node("Blaster")
onready var Shield = self.get_node("Shield")
onready var Flash_Timer = self.get_node("Flash_Timer")
onready var Particle = preload("res://Particle_Effect/Particle.tscn")

var number_generator = RandomNumberGenerator.new()

var disabled = true
var player_speed = 500.0
var is_making_grand_enterance = false

func _process(delta):
	if self.is_making_grand_enterance:
		self.make_grand_enterance()
	
	if self.disabled == true:
		return
	
	self.look_at_target()
	
	self.apply_user_movement()

func make_grand_enterance():
	self.position.y -= 300.0 * self.get_process_delta_time()
	if self.position.y < 650.0:
		self.position.y = 650.0
		self.is_making_grand_enterance = false
		self.emit_signal("entered_stage")

func start_new_game():
	self.position = Vector2(512, 1100)
	self.Player_Sprite.rotation = 0.0
	self.is_making_grand_enterance = true
	self.visible = true
	self.Shield.clear_shield_nodes()
	self.Blaster.clear_sigil_count()


func apply_user_movement():
	var direction = Vector2(0.0, 0.0)
	if Input.is_key_pressed(KEY_W):
		direction += Vector2(0.0, -1.0)
	if Input.is_key_pressed(KEY_S):
		direction += Vector2(0.0, 1.0)
	if Input.is_key_pressed(KEY_A):
		direction += Vector2(-1.0, 0.0)
	if Input.is_key_pressed(KEY_D):
		direction += Vector2(1.0, 0.0)
	direction = direction.normalized()
	var velocity = direction * player_speed
	self.move_and_slide(velocity)


func look_at_target():
	var mouse_position = self.get_global_mouse_position()
	self.Player_Sprite.look_at(mouse_position)
	self.Player_Sprite.rotate(PI / 2.0)

func _on_Sigil_Nexus_white_sigil_acquired(count):
	self.Shield.add_shield_node()
	if count == 0:
		self.Shield.clear_shield_nodes()

func _on_Sigil_Nexus_black_sigil_acquired(count):
	self.Blaster.added_sigil()
	if count == 0:
		self.Blaster.clear_sigil_count()


func _on_Area2D_area_entered(area):
	if self.disabled:
		return
	
	var groups = area.get_groups()
	if groups.has("Enemies"):
		self.do_hit_flash()
		var damage = area.get_parent().power
		if damage > self.Shield.shield_count:
			self.die()
		else:
			self.number_generator.randomize()
			var new_pitch = self.number_generator.randf_range(0.3, 1.0)
			self.Damage_SFX.pitch_scale = new_pitch
			self.Damage_SFX.play()
			self.Shield.remove_shield_node(damage)

func do_hit_flash():
	self.emit_signal("shake_requested", 0.5, 16.0)
	self.modulate = Color(1.0, 0.0, 0.0, 1.0)
	self.Flash_Timer.start()
	yield(self.Flash_Timer, "timeout")
	self.Flash_Timer.stop()
	self.modulate = Color(1.0, 1.0, 1.0, 1.0)

func disable():
	self.Blaster.disable()
	self.disabled = true

func enable():
	self.Blaster.disabled = false
	self.disabled = false


func die():
	self.visible = false
	self.emit_particles_die()
	self.number_generator.randomize()
	var new_pitch = self.number_generator.randf_range(0.5, 1.5)
	self.Death_SFX.pitch_scale = new_pitch
	self.Death_SFX.play()
	self.emit_signal("player_died")


func emit_particles_die():
	var New_Particles = Particle.instance()
	New_Particles.set_as_toplevel(true)
	New_Particles.global_position = self.global_position
	New_Particles.lifetime = 2.0
	New_Particles.amount = 50
	New_Particles.scale = Vector2(1.0, 1.0) * 4.0
	self.get_parent().add_child(New_Particles)