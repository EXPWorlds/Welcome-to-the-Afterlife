extends AnimatedSprite


signal sigil_collected

onready var Sigil_SFX = self.get_node("Sigil_SFX")
onready var Sigil_Area = self.get_node("Area2D")

var number_generator = RandomNumberGenerator.new()

var is_falling = false
var is_rotating = false
var fall_speed = 50.0
var rotation_speed = 0.0
var is_collidable = true

func _process(delta):
	
	if is_falling == true:
		self.position.y += fall_speed * delta

	if is_rotating:
		self.rotate(self.rotation_speed * delta)

	
	if self.position.y > 1200:
		self.queue_free()

func _on_Area2D_area_entered(area):
	if not self.is_collidable:
		return
	
	if area.name == "Bullet_Area":
		self.queue_free()
	
	if area.name == "Player":
		self.emit_signal("sigil_collected")
		self.visible = false
		self.Sigil_Area.queue_free()
		self.number_generator.randomize()
		var new_pitch = self.number_generator.randf_range(0.5, 1.5)
		self.Sigil_SFX.pitch_scale = new_pitch
		self.Sigil_SFX.play()

func _on_Sigil_SFX_finished():
	self.queue_free()
