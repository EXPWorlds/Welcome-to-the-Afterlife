extends Node2D

onready var Shield_Node = preload("res://Player/Shield/Shield_Node.tscn")
onready var Particle = preload("res://Particle_Effect/Particle.tscn")

var shield_count = 0
var number_generater = RandomNumberGenerator.new()

func add_shield_node():
	self.number_generater.randomize()
	var New_Shield_Node = Shield_Node.instance()
	var starting_rotation = self.number_generater.randf_range(0, PI * 2.0)
	var new_speed = self.number_generater.randf_range(PI, PI * 2.0)
	var new_direction = self.number_generater.randi_range(0, 1)
	if new_direction == 0:
		new_direction = -1
	New_Shield_Node.rotation = starting_rotation
	New_Shield_Node.rotate_speed = new_speed * new_direction
	self.add_child(New_Shield_Node)
	self.shield_count += 1


func remove_shield_node(amount):
	var shield_nodes = self.get_children()
	if not shield_nodes.empty():
		for node in range(amount):
			self.emit_particles(shield_nodes[node].global_position)
			shield_nodes[node].queue_free()
			self.shield_count -= 1

func clear_shield_nodes():
	var shield_nodes = self.get_children()
	self.shield_count = 0
	for node in shield_nodes:
		node.queue_free()

func emit_particles(position):
	var New_Particles = Particle.instance()
	New_Particles.set_as_toplevel(true)
	New_Particles.global_position = position
	New_Particles.lifetime = 0.3
	New_Particles.amount = 6
	New_Particles.scale = Vector2(1.0, 1.0) * 0.3
	self.get_parent().add_child(New_Particles)