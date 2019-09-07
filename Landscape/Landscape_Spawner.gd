extends Node2D

signal dialog_finished
signal gates_reached
signal started_moving

var spawner_on = true
onready var number_generater = RandomNumberGenerator.new()
onready var Hills = preload("res://Landscape/Landscapes/Landscape1.tscn")
onready var Empty_Pillar = preload("res://Landscape/Pillars/Piller_Empty.tscn")
onready var Fire_Pillar = preload("res://Landscape/Pillars/Pillar_Fire.tscn")
onready var Dead_Tree = preload("res://Landscape/Tree/Tree.tscn")
onready var Gates = preload("res://Landscape/Gates/Gates.tscn")
onready var Start_Location = preload("res://Landscape/Starting/Starting_Location.tscn")

export(Curve) var landscape_curve
var game_time = 0.0
var distance_to_gates = 1.0

func _process(delta):
	if not spawner_on:
		return
	
	var game_ratio = self.game_time / self.distance_to_gates
	var landscape_chance = self.landscape_curve.interpolate(game_ratio)
	
	if landscape_chance > 300.0:
		return
	
	self.number_generater.randomize()
	var spawn_check = number_generater.randi_range(1, landscape_chance)
	if spawn_check == 1:
		self.number_generater.randomize()
		var landscape_check = number_generater.randi_range(0,2)
		match landscape_check:
			0:
				self.spawn_hills()
			1:
				self.spawn_empty_pillar()
			2:
				self.spawn_fire_pillar()
			3:
				self.spawn_dead_tree()


func spawn_hills():
	self.number_generater.randomize()
	var spawn_location = self.number_generater.randi_range(-490, 490)
	var New_Landscape = self.Hills.instance()
	New_Landscape.position.x = spawn_location
	New_Landscape.speed = 40.0
	self.add_child(New_Landscape)
	self.move_child(New_Landscape, 0)
	New_Landscape.is_moving = true


func spawn_empty_pillar():
	self.number_generater.randomize()
	var spawn_location = self.number_generater.randi_range(-490, 490)
	var New_Landscape = self.Empty_Pillar.instance()
	New_Landscape.position.x = spawn_location
	New_Landscape.fall_speed = 40.0
	self.add_child(New_Landscape)
	self.move_child(New_Landscape, 0)
	New_Landscape.is_falling = true

func spawn_fire_pillar():
	self.number_generater.randomize()
	var spawn_location = self.number_generater.randi_range(-490, 490)
	var New_Landscape = self.Fire_Pillar.instance()
	New_Landscape.position.x = spawn_location
	New_Landscape.fall_speed = 40.0
	self.add_child(New_Landscape)
	self.move_child(New_Landscape, 0)
	New_Landscape.is_falling = true
	
func spawn_dead_tree():
	self.number_generater.randomize()
	var spawn_location = self.number_generater.randi_range(-490, 490)
	var New_Landscape = self.Dead_Tree.instance()
	New_Landscape.position.x = spawn_location
	New_Landscape.fall_speed = 40.0
	New_Landscape.scale = Vector2(3.0, 3.0)
	self.add_child(New_Landscape)
	self.move_child(New_Landscape, 0)
	New_Landscape.is_falling = true


func clear_landscapes():
	var children = self.get_children()
	for child in children:
		child.queue_free()

func _on_Dialog_Nexus_dialog_authorized(actor, time_per_char, read_time, zoom, wait, msg):
	if actor == self.name:
		match msg:
			"Spawn Gate":
				self.spawner_on = false
				var New_Gate = self.Gates.instance()
				New_Gate.position.y = -200
				self.add_child(New_Gate)
				New_Gate.connect("gates_reached", self, "_on_gates_reached")
		self.emit_signal("dialog_finished")


func _on_gates_reached():
	self.emit_signal("gates_reached")


func new_game():
	var Init_Start_Location = self.Start_Location.instance()
	Init_Start_Location.position = Vector2(0.0, 800)
	self.connect("started_moving", Init_Start_Location, "_on_started_moving")
	self.add_child(Init_Start_Location)


func _on_Game_Timer_ticked(current_time):
	self.game_time = current_time
