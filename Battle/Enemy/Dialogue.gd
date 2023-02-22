extends Node2D

# Credits to: JCW and Scarm.

onready var SpeechBubbleSpr: Texture = preload("res://Textures/SpeechBubble.png")

var DefaultFont: String = "res://Fonts/Resources/ComicSans.tres"
var DefaultSound: String = "res://Audio/SansVoice.ogg"
var DefaultPosition: Vector2 = Vector2(64, -128)
var DefaultSize: Vector2 = Vector2(200, 80)

var DialogueFont: = DefaultFont
var DialogueSound: = DefaultSound
var DialoguePosition: = DefaultPosition
var DialogueSize: = DefaultSize

var DialogueCount: int = 0


func Writer(Text: String, TextSpeed: float, SetSpeed: Dictionary, SetPause: Dictionary, Interactable: bool, Skip: bool, DestroyTime: float, CallNode: Node = null, CallFunc: String = "", CallArgs: Array = []) -> void:
	var SpeechBubble = Sprite.new()
	SpeechBubble.texture = SpeechBubbleSpr
	SpeechBubble.add_to_group("SpeechBubble")
	
	SpeechBubble.centered = false
	SpeechBubble.position = DefaultPosition
	add_child(SpeechBubble)
	
	RPGText.Writer(SpeechBubble, Text, Vector2(32, 16), DialogueSize, TextSpeed, SetSpeed, SetPause, DialogueFont, DialogueSound, Interactable, Skip, DestroyTime, Color.black, CallNode, CallFunc, CallArgs)


func Start() -> void:
	var Text: Array
	var Interaction: Array = [true, false, 0]
	
	DialogueFont = DefaultFont
	DialogueSound = DefaultSound
	DialoguePosition = DefaultPosition
	DialogueSize = DefaultSize
	
	match $"../../Attacks".AttackNum:
		1:
			Text = [
				["hey, kid. look at this new engine i found.", 0.03, {}, {}],
				["it's cool right?", 0.03, {}, {}],
				["imo, it's like [color=red]game maker[/color] but COOLER.", 0.03, {}, {}],
				["and i have more customizability without bothering to code them.", 0.03, {}, {}],
				["like, look. i can have custom time pauses!", 0.03, {}, {5 : 0.25, 11: 0.5}],
				["[tornado]i can have crazy messages without coding them.", 0.03, {}, {}],
				["[shake rate=25 level=10]i can dunk you harder now.", 0.06, {}, {}],
				["and all of this was very easy to make.", 0.03, {}, {}],
				["the engine's name is [color=#478CBF]godot[/color] by the way.", 0.03, {}, {}],
				["clickteam sucks. don't use it.", 0.03, {}, {16 : 0.5}],
			]
			match DialogueCount:
				1: get_tree().call_group("SansBattle", "BodyAnimation", "Shrug")
				2:
					get_tree().call_group("SansBattle", "HeadAnimation", "LookLeft")
					get_tree().call_group("SansBattle", "BodyAnimation", "Shrug")
				3:
					get_tree().call_group("SansBattle", "HeadAnimation", "Wink")
					get_tree().call_group("SansBattle", "BodyAnimation", "Shrug")
				4:
					get_tree().call_group("SansBattle", "HeadAnimation", "Default")
					get_tree().call_group("SansBattle", "BodyAnimation", "Default")
				5: get_tree().call_group("SansBattle", "HeadAnimation", "LookLeft")
				6:
					DialogueSound = ""
					get_tree().call_group("SansBattle", "HeadAnimation", "NoEyes")
				7: get_tree().call_group("SansBattle", "HeadAnimation", "EyesClosed")
				8: get_tree().call_group("SansBattle", "HeadAnimation", "Wink")
				9: get_tree().call_group("SansBattle", "HeadAnimation", "NoEyes")
		2:
			Text = [
				["what?", 0.03, {}, {}],
				["are you mad because i'm using a superior engine?", 0.03, {}, {}],
				["get good loser.", 0.03, {}, {}],
			]
			match DialogueCount:
				1: get_tree().call_group("SansBattle", "BodyAnimation", "Shrug")
				2:
					get_tree().call_group("SansBattle", "HeadAnimation", "Wink")
					get_tree().call_group("SansBattle", "BodyAnimation", "Shrug")
				3: get_tree().call_group("SansBattle", "HeadAnimation", "NoEyes")
		3:
			Text = [
				["hey, check this out.", 0.03, {}, {4 : 0.25}],
				["you're going to be [color=red]SPINNING[/color] a lot.", 0.03, {}, {}],
				["so, prepare your puke bag.", 0.03, {}, {3 : 0.5}],
			]
			match DialogueCount:
				1: get_tree().call_group("SansBattle", "HeadAnimation", "Wink")
	
	if !Text.empty():
		var Action = "Start" if DialogueCount < Text.size() - 1 else "End"
		Writer(Text[DialogueCount][0], Text[DialogueCount][1], Text[DialogueCount][2], Text[DialogueCount][3], Interaction[0], Interaction[1], Interaction[2], self, Action)
		DialogueCount += 1
	else:
		yield($"../../Border", "ResizeFinished")
		End()


func End() -> void:
	DialogueCount = 0
	$"../../Attacks".emit_signal("RunAttack")
	
	get_tree().call_group("SansBattle", "HeadAnimation", "Default")
	get_tree().call_group("SansBattle", "BodyAnimation", "Default")
