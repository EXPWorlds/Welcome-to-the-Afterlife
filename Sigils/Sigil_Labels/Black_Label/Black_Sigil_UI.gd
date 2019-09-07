extends Control

onready var Counter_Text = self.get_node("Counter_Label")

func _ready():
	self.Counter_Text.text = "0"

func _on_Sigil_Nexus_Clear():
	self.current_count = 0

func _on_Sigil_Nexus_black_sigil_acquired(count):
	self.Counter_Text.text = str(count)