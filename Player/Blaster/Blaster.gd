extends Node2D

onready var Fire_Timer = self.get_node("Fire_Timer")
onready var Bullet = preload("res://Player/Blaster/Bullet.tscn")
onready var Bullet_Root = self.get_node("Bullet_Root")

var disabled = true

var number_generator = RandomNumberGenerator.new()
var current_blaster_power = 1.0

func _ready():
	self.Fire_Timer.start()
	self.Fire_Timer.paused = true

func _process(delta):
	if self.disabled:
		return
	
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		self.Fire_Timer.paused = false
	else:
		self.Fire_Timer.paused = true

func _unhandled_input(event):
	if self.disabled:
		return
	
	if event is InputEventMouseButton:
		if event.pressed:
			self.fire()

func _on_Fire_Timer_timeout():
	self.fire()

func added_sigil():
	self.current_blaster_power += 1.0

func clear_sigil_count():
	self.current_blaster_power = 1.0

func fire():
	self.number_generator.randomize()
	var mouse_position = self.get_global_mouse_position()
	var New_Bullet = Bullet.instance()
	New_Bullet.speed = number_generator.randi_range(500, 700)
	self.Bullet_Root.add_child(New_Bullet)
	New_Bullet.enroute = true
	self.Fire_Timer.wait_time = 0.01 + (1.0 / self.current_blaster_power)

func disable():
	self.disabled = true
	self.Fire_Timer.paused = true