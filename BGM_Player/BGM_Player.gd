extends AudioStreamPlayer

signal faded_out
signal faded_in

onready var Main_Theme = preload("res://BGM_Player/BG_Music/MainTheme.ogg")
onready var Funny_Banter = preload("res://BGM_Player/BG_Music/Funny_Banter.ogg")

var fade_time = 3.0
var volume_delta = 0.0
var target_volume = 0.0
var is_fading_in = false
var is_fading_out = false


func _process(delta):
	
	if self.is_fading_in:
		self.volume_db += self.volume_delta * delta
		if self.volume_db >= self.target_volume:
			self.volume_db = self.target_volume
			self.is_fading_in = false
			self.emit_signal("faded_in")

	
	if self.is_fading_out:
		self.volume_db -= self.volume_delta * delta
		if self.volume_db <= -80.0:
			self.volume_db = -80.0
			self.is_fading_out = false
			self.emit_signal("faded_out")
		

func change_bg_music_to(track, volume, fade_out, fade_in):
	self.fade_out(fade_out)
	yield(self, "faded_out")
	self.play_bg_music(track, volume, fade_in)

func play_bg_music(track, volume, fade_in):
	self.target_volume = volume
	self.fade_time = fade_in
	match track:
		"Main":
			self.stream = Main_Theme
			self.play()
			self.fade_in()
		"Banter":
			self.stream = Funny_Banter
			self.play()
			self.fade_in()


func fade_in():
	if self.fade_time == 0.0:
		self.volume_db = self.target_volume
		return
	
	self.volume_db = -80.0
	var volume_actual = (self.volume_db + 80.0)
	var target_volume_actual = (self.target_volume + 80.0)
	var distance = abs(target_volume_actual - volume_actual)
	self.volume_delta = distance / self.fade_time
	self.is_fading_out = false
	self.is_fading_in = true


func fade_out(fade_out_time):
	self.fade_time = fade_out_time
	var volume_actual = (self.volume_db + 80.0)
	self.volume_delta = volume_actual / self.fade_time
	self.is_fading_in = false
	self.is_fading_out = true