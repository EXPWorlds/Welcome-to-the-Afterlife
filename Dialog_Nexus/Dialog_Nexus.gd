extends Node

signal dialog_authorized
signal skipped_content

onready var Skip_Button = self.get_node("Skip_Button")

var dialog_queue : Array
var dialog_busy = false

var white_sigil_count = 0
var black_sigil_count = 0

func _ready():
	self.Skip_Button.visible = false

func _on_Dialog_Request(actor, time_per_char, read_time, zoom, wait, msg):
	if not dialog_busy:
		self.emit_signal("dialog_authorized", actor, time_per_char, read_time, zoom, wait, msg)
		dialog_busy = true
	else:
		dialog_queue.push_back(actor)
		dialog_queue.push_back(time_per_char)
		dialog_queue.push_back(read_time)
		dialog_queue.push_back(zoom)
		dialog_queue.push_back(wait)
		dialog_queue.push_back(msg)


func _on_Dialog_Finished():
	if not dialog_queue.empty():
		self.emit_signal("dialog_authorized", dialog_queue.pop_front(), dialog_queue.pop_front(), dialog_queue.pop_front(), dialog_queue.pop_front(), dialog_queue.pop_front(), dialog_queue.pop_front())
	else:
		self.dialog_busy = false

func load_convo(conversation, skippable):
	for element in conversation:
		self.dialog_queue.push_back(element)
	if skippable:
		self.Skip_Button.visible = true
	self._on_Dialog_Finished()

func clear_dialog():
	self.dialog_queue.clear()
	self.dialog_busy = false

func get_convo(number):
	match number:
		"intro":
			return ["Demon", 0.02, 1.0, true, false, "Hey!",
			"Demon", 0.02, 1.0, true, true, "Hey, you! You new round here?",
			"Demon", 0.02, 1.0, true, true, "Heh, thought so. Hate to break it to ya, but you're dead.",
			"Demon", 0.02, 1.0, true, false, "Ya, know! Kicked the bucket...",
			"Demon", 0.02, 1.0, true, false, "Shuffled off the mortal coil...",
			"Demon", 0.02, 1.0, true, false, "Kissed the lips of the frozen moose...",
			"Angel", 0.02, 1.0, true, true, "Jeez, why must you be so graphic?...",
			"Angel", 0.02, 1.0, true, true, "...and that last one isn't even a thing.",
			"Demon", 0.02, 1.0, false, false, "...whatever...",
			"Angel", 0.02, 1.0, true, true, "Don't pay this dimwit any mind.",
			"Angel", 0.02, 1.0, true, true, "My name is Sabriel. Sabriel the angel. If the look wasn't telling enouph.",
			"Demon", 0.02, 1.0, true, true, "My name'z Ose. Ose the demon.",
			"Angel", 0.02, 1.0, false, false, "Yeah, yeah... no one cares...",
			"Angel", 0.02, 1.0, true, true, "Maybe I can help you out. I know my way around here. You'll be wanting to head to Heaven.",
			"Demon", 0.02, 1.0, true, true, "Ahhhh, naw, the one doing the helping'z gonna be me. You really wanna come party with me in Hell.",
			"Angel", 0.02, 1.0, true, true, "HA, more like become some devil's party favor. Don't believe a word he says, he's a DEMON, a deceiver!",
			"Demon", 0.02, 1.0, true, true, "The only liar round here is you, Sabriel! I've seen it!",
			"Demon", 0.02, 1.0, true, true, "Everyone who'z ever wandered off with her ends up a slave.",
			"Angel", 0.02, 1.0, false, false, "Silence, Demon! You have no idea what you're talking about.",
			"Angel", 0.02, 1.0, true, false, "Anyway, sorry about him.",
			"Angel", 0.02, 1.0, true, true, "If you want to get to Heaven, you'll need to collect 'White Sigils' to purify your soul and get rid of earthly sins.",
			"Angel", 0.02, 1.0, true, true, "They will also protect you from the wandering souls on the way to Heaven's gates.",
			"Angel", 0.02, 1.0, true, true, "As you are now, one hit, and *poof*, it's oblivian for you.",
			"Demon", 0.02, 1.0, true, true, "*Ehem* And, if you wanna rock out in Hell with me, you'll need to collect 'Black Sigils'",
			"Demon", 0.02, 1.0, true, true, "I'm real cosy with Hell's gatekeeper, Eugine. Get enouph o'them sigils and I can get you in.",
			"Demon", 0.02, 1.0, true, true, "They'll also make ya crazy powerful. Just blast them wandering souls outta ya way.",
			"Demon", 0.02, 1.0, true, true, "But... be careful not to mow down them sigils along with the souls. They can't take a beat'en like that.",
			"Angel", 0.02, 1.0, true, true, "I guess it's up to you to decide who to believe and who is a... BIG... FAT... LIAR.",
			"Angel", 0.02, 0.5, false, false, "*cough* *couph* Liar says, 'what'.",
			"Demon", 0.02, 0.5, false, false, "Wat?",
			"Angel", 0.02, 0.5, false, false, "heheh, never get's old...",
			"Angel", 0.02, 1.0, true, false, "By the way...",
			"Angel", 0.02, 1.0, true, true, "The 'Big Man Upstairs' asked me to pass along some advice...",
			"Angel", 0.02, 1.0, true, true, "'Move with WASD. Aim with the mouse icon. Hold down the left mouse button to fire.'....?",
			"Angel", 0.02, 1.0, true, true, "I don't understand what that means, but he says you'll get it...",
			"Demon", 0.02, 0.5, true, true, "Maybe yal get lucky and the wandering souls'll leave ya alone... Are you ready to head out?",
			"Demon", 0.02, 1.0, true, false, "Sweet, next stop Hell's door!",
			"Angel", 0.02, 1.0, false, false, "You mean Heaven's gates...",
			"Game", 0.1, 1.0, false, true, "Finished"]
		"soulfire":
			return ["Demon", 0.02, 3.0, false, false, "Heads up, that purple soul fire'z nasty business.",
			"Demon", 0.02, 2.0, false, false, "Get some 'Black Sigils' to blow it away.",
			"Angel", 0.02, 2.0, false, false, "Better to collect 'White Sigils' to protect yourself",
			"Demon", 0.02, 2.0, false, false, "Ahhhh, put a lid on it, ya broken record."]
		"boss_spawned":
			return ["Demon", 0.02, 3.0, true, true, "Yo, watch ya-self. Something big'z coming this way.",
			"Angel", 0.02, 2.0, true, true, "Jeez, I've never seen a wandering soul this powerful.",
			"Angel", 0.02, 2.0, true, true, "It must be ancient, be careful.",
			"Demon", 0.02, 2.0, true, true, "Ya ready to rek this beastie?",
			"Obstacle_Spawner", self.black_sigil_count, self.white_sigil_count, false, false, "Spawn Boss",
			"Game", 0.1, 1.0, false, true, "Finished"]
		"boss_defeated":
			return ["Demon", 0.02, 3.0, true, true, "Wow, nice going, ya really blew his arse outta the sky.",
			"Angel", 0.02, 2.0, true, false, "Yes, that was quite impressive...",
			"Angel", 0.02, 2.0, true, true, "Heaven's gates are just a little further ahead. Let's keep moving.",
			"Demon", 0.02, 3.0, true, true, "That'z right, soon we can ditch this fairy winged loser and get this party started.",
			"Angel", 0.02, 2.0, false, false, "Oh, for God's sake.....you have wings too.....",
			"Landscape_Spawner", 0.02, 2.0, false, false, "Spawn Gate",
			"Game", 0.1, 1.0, false, true, "Finished"]
		"end_win":
			return ["Demon", 0.02, 3.0, true, true, "Here we are. The gates.",
			"Angel", 0.02, 3.0, true, true, "Let's check how many Sigils you managed to collect. You'll only be needing the White Sigils, of course...",
			"Demon", 0.02, 2.0, false, false, "*HA* Yeah, right...!",
			"Demon", 0.02, 3.0, false, true, "Only if you want me ta knock ya clear outta that pretty blue robe.",
			"Demon", 0.02, 3.0, true, true, "How many of them Black Sigils ya got?",
			"Angel", 0.02, 2.0, true, false, "Let's see...",
			"Angel", 0.02, 3.0, true, true, ("Looks like you collected " + str(self.white_sigil_count) + " White Sigils..."),
			"Demon", 0.02, 3.0, true, true, ("...and ya got " + str(self.black_sigil_count) + " Black Sigils..."),
			"Angel", 0.02, 2.0, false, false, ".................................",
			"Demon", 0.02, 2.0, false, false, ".................................",
			"Angel", 0.02, 1.0, false, false, "YOU MEAN...?",
			"Angel", 0.02, 1.0, true, true, "...YOU DIDN'T COLLECT ANY SIGILS AT ALL!!!?",
			"Demon", 0.02, 2.0, true, false, "NONE AT ALL!?",
			"Angel", 0.02, 1.0, false, false, "RATZ! I really could have used a new slave too...",
			"Angel", 0.02, 1.0, true, true, "I... I mean, really wanted to show you around Heaven...",
			"Demon", 0.02, 1.0, false, true, "Cut the act Sabriel, the jig is up. This one is too smart.",
			"Demon", 0.02, 1.0, true, true, "Drat, and here I thought ya'd be gullible enouph to sacrafice...",
			"Demon", 0.02, 1.0, false, true, "What do we do now?",
			"Angel", 0.02, 1.0, false, true, "Well since neither of us has a claim over this soul, I suppose it's free to go...",
			"Demon", 0.02, 1.0, false, true, "Go where?",
			"Angel", 0.02, 1.0, true, true, "If you stay here, you'll just become a wandering soul, and an even bigger pain in my holy backside...",
			"Angel", 0.02, 1.0, true, true, "...so, take the third gate.",
			"Demon", 0.02, 1.0, false, true, "Really!! Back to the realm of the living?",
			"Demon", 0.02, 1.0, true, true, "I don't envy ya... that place suckz.",
			"Angel", 0.02, 1.0, true, true, "Begone with you... you won't be so lucky next time...",
			"Game", 0.1, 1.0, false, true, "Finished"]
		"end_tie":
			return ["Demon", 0.02, 3.0, true, true, "Here we are. The gates.",
			"Angel", 0.02, 3.0, true, true, "Let's check how many Sigils you managed to collect. You'll only be needing the White Sigils, of course...",
			"Demon", 0.02, 2.0, false, false, "*HA* Yeah, right...!",
			"Demon", 0.02, 3.0, false, true, "Only if you want me ta knock ya clear outta that pretty blue robe.",
			"Demon", 0.02, 3.0, true, true, "How many of them Black Sigils ya got?",
			"Angel", 0.02, 2.0, true, false, "Let's see...",
			"Angel", 0.02, 3.0, true, true, ("Looks like you collected " + str(self.white_sigil_count) + " White Sigils..."),
			"Demon", 0.02, 3.0, true, true, ("...and ya got " + str(self.black_sigil_count) + " Black Sigils..."),
			"Angel", 0.02, 2.0, false, false, ".................................",
			"Demon", 0.02, 2.0, false, false, ".................................",
			"Demon", 0.02, 3.0, false, true, "It's a tie! Now what do we do?",
			"Angel", 0.02, 3.0, false, true, "I have an idea. We both can still get... half of what we want...",
			"Demon", 0.02, 3.0, false, true, "How'z that?",
			"Angel", 0.02, 3.0, false, true, "We'll tear this soul in two!!!",
			"Demon", 0.02, 3.0, false, true, "Right down the middle!!! Fair is fair!",
			"Angel", 0.02, 3.0, true, true, "Sorry about this, but that'll teach you not to use powers you don't understand.",
			"Game", 0.1, 1.0, false, true, "Finished"]
		"end_white":
			return ["Demon", 0.02, 3.0, true, true, "Here we are. The gates.",
			"Angel", 0.02, 3.0, true, true, "Let's check how many Sigils you managed to collect. You'll only be needing the White Sigils, of course...",
			"Demon", 0.02, 2.0, false, false, "*HA* Yeah, right...!",
			"Demon", 0.02, 3.0, false, true, "Only if you want me ta knock ya clear outta that pretty blue robe.",
			"Demon", 0.02, 3.0, true, true, "How many of them Black Sigils ya got?",
			"Angel", 0.02, 2.0, true, false, "Let's see...",
			"Angel", 0.02, 3.0, true, true, ("Looks like you collected " + str(self.white_sigil_count) + " White Sigils..."),
			"Demon", 0.02, 3.0, true, true, ("...and ya got " + str(self.black_sigil_count) + " Black Sigils..."),
			"Angel", 0.02, 2.0, false, false, ".................................",
			"Demon", 0.02, 2.0, false, false, ".................................",
			"Angel", 0.02, 1.0, false, false, "BWAHAHAHAHAHAHAHAHA...",
			"Angel", 0.02, 1.0, false, true, "For using my White Sigils, this soul now belongs to me!!!",
			"Demon", 0.02, 1.0, false, false, "AWWW man.......",
			"Angel", 0.02, 1.0, true, true, "You're my slave now! Bow before your new master!",
			"Demon", 0.02, 2.0, true, false, "Sorry friend...",
			"Demon", 0.02, 3.0, true, false, "I did try ta warn ya. Sabriel'z not kewl at all.",
			"Demon", 0.02, 2.0, true, true, "If ya had enouph Black Sigils we'd be partying together in Hell by now...",
			"Angel", 0.02, 1.0, true, true, "Enouph! Stop talking with the Demon. Come slave, we're leaving.",
			"Angel", 0.02, 1.0, false, true, "The first thing you're gonna do when we get home is lick masters toes...",
			"Demon", 0.02, 1.0, false, false, "....eww, gross, good luck with that...",
			"Game", 0.1, 1.0, false, true, "Finished"]
		"end_black":
			return ["Demon", 0.02, 3.0, true, true, "Here we are. The gates.",
			"Angel", 0.02, 3.0, true, true, "Let's check how many Sigils you managed to collect. You'll only be needing the White Sigils, of course...",
			"Demon", 0.02, 2.0, false, false, "*HA* Yeah, right...!",
			"Demon", 0.02, 3.0, false, true, "Only if you want me ta knock ya clear outta that pretty blue robe.",
			"Demon", 0.02, 3.0, true, true, "How many of them Black Sigils ya got?",
			"Angel", 0.02, 2.0, true, false, "Let's see...",
			"Angel", 0.02, 3.0, true, true, ("Looks like you collected " + str(self.white_sigil_count) + " White Sigils..."),
			"Demon", 0.02, 3.0, true, true, ("...and ya got " + str(self.black_sigil_count) + " Black Sigils..."),
			"Angel", 0.02, 2.0, false, false, ".................................",
			"Demon", 0.02, 2.0, false, false, ".................................",
			"Demon", 0.02, 1.0, false, false, "BWAHAHAHAHAHAHAHAHA...",
			"Demon", 0.02, 1.0, false, true, "For using ma Black Sigils, this soul now belongs to me!!!",
			"Angel", 0.02, 1.0, true, true, "RATZ! I'm sorry, I tried to warn you not to trust Demons. Especially, Ose...",
			"Angel", 0.02, 2.0, true, true, "I'm afraid there's nothing I can't do to help you. I have no claim to your soul.",
			"Demon", 0.02, 1.0, false, true, "Not so much of a loser now, am I Sabriel?",
			"Demon", 0.02, 1.0, true, true, "Come with me slave! We have work to do.",
			"Demon", 0.02, 1.0, true, true, "Sacrificing ya soul is ma ticket to the big league. All will fear Ose, the bestest Demon ever.",
			"Angel", 0.02, 2.0, false, false, "Jeez, what a ding dong for brains...",
			"Game", 0.1, 1.0, false, true, "Finished"]




func _on_Skip_Button_pressed():
	self.Skip_Button.visible = false
	self.clear_dialog()
	self.emit_signal("skipped_content")


func _on_Dialog_Nexus_dialog_authorized(actor, time_per_char, read_time, zoom, wait, msg):
	if actor == "Game":
		if msg == "Finished":
			self.Skip_Button.visible = false


func _on_Game_Timer_ticked(current_time):
	match current_time:
		10:
			self.load_convo(self.get_convo("soulfire"), false)


func _on_Sigil_Nexus_black_sigil_acquired(count):
	self.black_sigil_count = count


func _on_Sigil_Nexus_white_sigil_acquired(count):
	self.white_sigil_count = count

