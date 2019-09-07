extends Control

signal convo_finished

onready var Splash_Screen = self.get_node("Splash_Screen")
onready var Main_Menu = self.get_node("Menu")
onready var End = self.get_node("End")
onready var UI = self.get_node("UI")

onready var Dialog_Nexus = self.get_node("Dialog_Nexus")
onready var Sigil_Nexus = self.get_node("Sigil_Nexus")

onready var Landscape_Spawner = self.get_node("Landscape_Spawner")
onready var Sigil_Spawner = self.get_node("Sigil_Spawner")
onready var Obstacle_Spawner = self.get_node("Obstacle_Spawner")

onready var Game_Timer = self.get_node("Game_Timer")
onready var Progress_Meter = self.get_node("UI/Progress_Meter")

onready var Player = self.get_node("Player")

onready var BGM_Player = self.get_node("BGM_Player")

var distance_to_gates = 360.0

var white_sigil_count = 0
var black_sigil_count = 0

func _ready():
	self.initialize_settings()
	self.Splash_Screen.do_splash_screen()
	

func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_ESCAPE:
			self.exit_game()


func initialize_settings():
	self.UI.visible = false
	self.End.visible = false
	self.Player.visible = false
	self.Landscape_Spawner.spawner_on = false
	self.Sigil_Spawner.spawner_on = false
	self.Sigil_Spawner.distance_to_gates = self.distance_to_gates
	self.Obstacle_Spawner.spawner_on = false
	self.Obstacle_Spawner.distance_to_gates = self.distance_to_gates
	self.Landscape_Spawner.distance_to_gates = self.distance_to_gates
	self.Progress_Meter.max_value = self.distance_to_gates
	self.Progress_Meter.value = 0
	self.Main_Menu.initialize_settings()


func _on_Dialog_Nexus_dialog_authorized(actor, time_per_char, read_time, zoom, wait, msg):
	if actor == self.name:
		if msg == "Finished":
			self.emit_signal("convo_finished")


func _on_Dialog_Nexus_skipped_content():
	self.emit_signal("convo_finished")


func start_new_game():
	self.Dialog_Nexus.clear_dialog()
	self.BGM_Player.change_bg_music_to("Banter", 0.0, 3.0, 0.0)
	self.Main_Menu.is_fading_out = true
	self.UI.modulate.a = 0.0
	self.UI.visible = true
	self.Landscape_Spawner.new_game()
	self.UI.is_fading_in = true
	self.Progress_Meter.value = 0
	yield(self.UI, "faded_in")
	self.Player.start_new_game()
	yield(self.Player, "entered_stage")
	self.Dialog_Nexus.load_convo(self.Dialog_Nexus.get_convo("intro"), true)
	yield(self, "convo_finished")
	self.Player.enable()
	self.Landscape_Spawner.spawner_on = true
	self.Landscape_Spawner.emit_signal("started_moving")
	self.BGM_Player.fade_out(3.0)
	self.Sigil_Spawner.spawner_on = true
	self.Obstacle_Spawner.spawner_on = true
	self.Game_Timer.reset_game_time()
	self.Game_Timer.start()
	


func _on_Menu_pressed_play():
	self.start_new_game()


func _on_Menu_pressed_quit():
	self.exit_game()


func exit_game():
	get_tree().quit()

func _on_Player_player_died():
	self.Player.disable()
	self.BGM_Player.stop()
	self.Landscape_Spawner.spawner_on = false
	self.Sigil_Spawner.spawner_on = false
	self.Obstacle_Spawner.spawner_on = false
	self.Player.visible = false
	self.End.visible = true
	self.Game_Timer.stop()
	self.End.load_texture("game over")
	self.End.set_wait_time(5.0)
	self.End.is_fading_in = true
	yield(self.End, "faded_in")
	self.UI.visible = false
	self.Sigil_Nexus.clear_sigil_count()
	self.Landscape_Spawner.clear_landscapes()
	self.Sigil_Spawner.clear_sigils()
	self.Obstacle_Spawner.clear_obstacles()
	self.Main_Menu.initialize_settings()
	self.Main_Menu.modulate.a = 1.0

func _on_Obstacle_Spawner_boss_battle_begun():
	self.Sigil_Spawner.spawner_on = false
	self.Dialog_Nexus.load_convo(self.Dialog_Nexus.get_convo("boss_spawned"), false)
	yield(self, "convo_finished")
	self.BGM_Player.play_bg_music("Main", -6.0, 2.0)


func _on_Obstacle_Spawner_boss_defeated():
	self.BGM_Player.stop()
	yield(get_tree().create_timer(2.0), "timeout")
	self.Dialog_Nexus.load_convo(self.Dialog_Nexus.get_convo("boss_defeated"), false)
	yield(self, "convo_finished")
	self.BGM_Player.play_bg_music("Banter", 0.0, 0.0)

func _on_Landscape_Spawner_gates_reached():
	self.Player.disable()
		
	if self.black_sigil_count == 0 and self.white_sigil_count == 0:
		self.Dialog_Nexus.load_convo(self.Dialog_Nexus.get_convo("end_win"), true)
		self.End.load_texture("end_win")
	elif self.black_sigil_count == self.white_sigil_count:
		self.Dialog_Nexus.load_convo(self.Dialog_Nexus.get_convo("end_tie"), true)
		self.End.load_texture("end_tie")
	elif self.black_sigil_count > self.white_sigil_count:
		self.Dialog_Nexus.load_convo(self.Dialog_Nexus.get_convo("end_black"), true)
		self.End.load_texture("end_black")
	elif self.black_sigil_count < self.white_sigil_count:
		self.Dialog_Nexus.load_convo(self.Dialog_Nexus.get_convo("end_white"), true)
		self.End.load_texture("end_white")
	yield(self, "convo_finished")
	self.BGM_Player.fade_out(3.0)
	
	yield(get_tree().create_timer(3.0), "timeout")
	
	self.End.visible = true
	self.End.set_wait_time(5.0)
	self.End.is_fading_in = true
	yield(self.End, "faded_in")
	self.Player.visible = false
	self.UI.visible = false
	self.Sigil_Nexus.clear_sigil_count()
	self.Game_Timer.stop()
	self.Landscape_Spawner.clear_landscapes()
	self.Sigil_Spawner.clear_sigils()
	self.Obstacle_Spawner.clear_obstacles()
	self.Main_Menu.initialize_settings()
	self.Main_Menu.modulate.a = 1.0

func _on_Sigil_Nexus_black_sigil_acquired(count):
	self.black_sigil_count = count


func _on_Sigil_Nexus_white_sigil_acquired(count):
	self.white_sigil_count = count

func _on_Splash_Screen_started_menu_fade_in():
	self.BGM_Player.play_bg_music("Main", 0.0, 0.0)


func _on_End_started_fading_out():
	self.BGM_Player.play_bg_music("Main", -3.0, 1.0)
