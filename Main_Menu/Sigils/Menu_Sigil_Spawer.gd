extends Node2D

onready var White_Sigil = preload("res://Sigils/White/While_Sigil.tscn")
onready var Black_Sigil = preload("res://Sigils/Black/Black_Sigil.tscn")

onready var W_Sigil_Texture1 = load("res://Sigils/White/Sprites/1.png")
onready var W_Sigil_Texture2 = load("res://Sigils/White/Sprites/2.png")
onready var W_Sigil_Texture3 = load("res://Sigils/White/Sprites/3.png")
onready var W_Sigil_Texture4 = load("res://Sigils/White/Sprites/4.png")
onready var W_Sigil_Texture5 = load("res://Sigils/White/Sprites/5.png")

onready var B_Sigil_Texture1 = load("res://Sigils/Black/Sprites/1.png")
onready var B_Sigil_Texture2 = load("res://Sigils/Black/Sprites/2.png")
onready var B_Sigil_Texture3 = load("res://Sigils/Black/Sprites/3.png")
onready var B_Sigil_Texture4 = load("res://Sigils/Black/Sprites/4.png")
onready var B_Sigil_Texture5 = load("res://Sigils/Black/Sprites/5.png")

var spawner_on = false
onready var number_generater = RandomNumberGenerator.new()

func _process(delta):
	if not spawner_on:
		return

	self.number_generater.randomize()
	var spawn_check = number_generater.randi_range(1, 50)
	if spawn_check == 1:
		self.number_generater.randomize()
		var BlackWhite_Check = number_generater.randi_range(0,1)
		if BlackWhite_Check == 0:
			self.spawn_black_sigil()
		else:
			self.spawn_white_sigil()

func spawn_black_sigil():
	self.number_generater.randomize()
	var spawn_location = self.number_generater.randi_range(-490, 490)
	var New_Black_Sigil = Black_Sigil.instance()
	New_Black_Sigil.position.x = spawn_location
	New_Black_Sigil.is_falling = true
	New_Black_Sigil.fall_speed = 50.0
	New_Black_Sigil.scale = Vector2(2.0, 2.0)
	New_Black_Sigil.is_collidable = false
	New_Black_Sigil.rotation_speed = 0.5
	New_Black_Sigil.is_rotating = true
	New_Black_Sigil.modulate.a = 0.25
	var sigil_texture = self.number_generater.randi_range(1, 5)
	var sigil_size = self.number_generater.randf_range(.5, 0.75)
	New_Black_Sigil.scale *= sigil_size
	var New_Sprite_Atlas = SpriteFrames.new()
	New_Black_Sigil.frames = New_Sprite_Atlas
	match sigil_texture:
		1:
			New_Black_Sigil.frames.add_frame("default", self.B_Sigil_Texture1)
		2:
			New_Black_Sigil.frames.add_frame("default", self.B_Sigil_Texture2)
		3:
			New_Black_Sigil.frames.add_frame("default", self.B_Sigil_Texture3)
		4:
			New_Black_Sigil.frames.add_frame("default", self.B_Sigil_Texture4)
		5:
			New_Black_Sigil.frames.add_frame("default", self.B_Sigil_Texture5)
	self.add_child(New_Black_Sigil)


func spawn_white_sigil():
	self.number_generater.randomize()
	var spawn_location = self.number_generater.randi_range(-490, 490)
	var New_White_Sigil = White_Sigil.instance()
	New_White_Sigil.position.x = spawn_location
	New_White_Sigil.is_falling = true
	New_White_Sigil.fall_speed = 50.0
	New_White_Sigil.scale = Vector2(2.0, 2.0)
	New_White_Sigil.is_collidable = false
	New_White_Sigil.rotation_speed = -0.5
	New_White_Sigil.is_rotating = true
	var sigil_texture = self.number_generater.randi_range(1, 5)
	var sigil_size = self.number_generater.randf_range(.5, 0.75)
	New_White_Sigil.modulate.a = 0.5
	New_White_Sigil.scale *= sigil_size
	var New_Sprite_Atlas = SpriteFrames.new()
	New_White_Sigil.frames = New_Sprite_Atlas
	match sigil_texture:
		1:
			New_White_Sigil.frames.add_frame("default", self.W_Sigil_Texture1)
		2:
			New_White_Sigil.frames.add_frame("default", self.W_Sigil_Texture2)
		3:
			New_White_Sigil.frames.add_frame("default", self.W_Sigil_Texture3)
		4:
			New_White_Sigil.frames.add_frame("default", self.W_Sigil_Texture4)
		5:
			New_White_Sigil.frames.add_frame("default", self.W_Sigil_Texture5)
	self.add_child(New_White_Sigil)


func clear_sigils():
	var children = self.get_children()
	for child in children:
		child.queue_free()