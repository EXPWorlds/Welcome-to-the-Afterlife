extends Node2D

signal dialog_finished
signal shake_requested
signal boss_defeated
signal boss_battle_begun


onready var FireSpinner = preload("res://Obstacles/FireSpinner/Fire_Spinner.tscn")
onready var SoulFire = preload("res://Obstacles/FireSpinner/Soulfire.tscn")
onready var FireSpitter = preload("res://Obstacles/FireSpitter/FireSpitter.tscn")
onready var FireBlaster = preload("res://Obstacles/FireBlaster/Fireblaster.tscn")
onready var Boss = preload("res://Obstacles/Boss/Boss.tscn")


export(Curve) var soulfire_curve
export(Curve) var firespinner_curve
export(Curve) var firespitter_curve
export(Curve) var fireblaster_curve

var spawner_on = true
onready var number_generater = RandomNumberGenerator.new()
var game_time = 0.0
var distance_to_gates = 1.0

func _process(delta):
	if not spawner_on:
		return
	
	var game_ratio = self.game_time / self.distance_to_gates
	
	self.number_generater.randomize()
	var soulfire_chance = self.soulfire_curve.interpolate(game_ratio)
	if soulfire_chance < 150:
		var soulfire_check = number_generater.randi_range(1, soulfire_chance)
		if soulfire_check == 1:
			self.spawn_soulfire()
	
	self.number_generater.randomize()
	var firespinner_chance = self.firespinner_curve.interpolate(game_ratio)
	if firespinner_chance < 900:
		var firespinner_check = number_generater.randi_range(1, firespinner_chance)
		if firespinner_check == 1:
			self.spawn_firespinner()
	
	self.number_generater.randomize()
	var firespitter_chance = self.firespitter_curve.interpolate(game_ratio)
	if firespitter_chance < 900:
		var firespitter_check = number_generater.randi_range(1, firespitter_chance)
		if firespitter_check == 1:
			self.spawn_firespitter()
	
	self.number_generater.randomize()
	var fireblaster_chance = self.fireblaster_curve.interpolate(game_ratio)
	if fireblaster_chance < 900:
		var fireblaster_check = number_generater.randi_range(1, fireblaster_chance)
		if fireblaster_check == 1:
			self.spawn_fireblaster()
	
	


func spawn_soulfire():
	var New_Soulfire = self.SoulFire.instance()
	self.number_generater.randomize()
	var x_position = number_generater.randi_range(-490, 490)
	New_Soulfire.position.x = x_position
	New_Soulfire.is_falling = true
	self.add_child(New_Soulfire)
	
	

func spawn_firespinner():
	self.number_generater.randomize()
	var spawn_location = self.number_generater.randi_range(-490, 490)
	var New_Firespinner = FireSpinner.instance()
	New_Firespinner.position.x = spawn_location
	self.add_child(New_Firespinner)
	New_Firespinner.connect("shake_requested", self, "_on_shake_requested")
	New_Firespinner.is_moving = true


func spawn_firespitter():
	self.number_generater.randomize()
	var spawn_location = self.number_generater.randi_range(-490, 490)
	var New_Firespitter = FireSpitter.instance()
	New_Firespitter.position.x = spawn_location
	self.add_child(New_Firespitter)
	New_Firespitter.connect("shake_requested", self, "_on_shake_requested")
	New_Firespitter.is_falling = true


func spawn_fireblaster():
	self.number_generater.randomize()
	var spawn_location = self.number_generater.randi_range(-490, 490)
	var New_Fireblaster = FireBlaster.instance()
	New_Fireblaster.position.x = spawn_location
	self.add_child(New_Fireblaster)
	New_Fireblaster.connect("shake_requested", self, "_on_shake_requested")
	New_Fireblaster.is_falling = true


func _on_shake_requested(duration, amplitude):
	self.emit_signal("shake_requested", duration, amplitude)

func _on_Game_Timer_ticked(current_time):
	self.game_time = current_time
	if self.game_time == self.distance_to_gates - 30.0:
			self.spawner_on = false
	if self.game_time == self.distance_to_gates:
			self.spawn_boss()


func clear_obstacles():
	var children = self.get_children()
	for child in children:
		child.queue_free() 


func spawn_boss():
	self.spawner_on = false
	self.emit_signal("boss_battle_begun")

func _on_boss_defeated():
	self.emit_signal("boss_defeated")

func _on_Dialog_Nexus_dialog_authorized(actor, time_per_char, read_time, zoom, wait, msg):
	if actor == self.name:
		match msg:
			"Spawn Boss":
				var New_Boss = Boss.instance()
				New_Boss.position = Vector2(0, 0)
				New_Boss.black_sigil_count = time_per_char
				New_Boss.white_sigil_count = read_time
				self.add_child(New_Boss)
				New_Boss.connect("shake_requested", self, "_on_shake_requested")
				New_Boss.connect("boss_defeated", self, "_on_boss_defeated")
		self.emit_signal("dialog_finished")
