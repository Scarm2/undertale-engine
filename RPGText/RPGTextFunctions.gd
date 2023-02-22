extends Node

# Credits to: Scarm.

onready var Preload: Resource = preload("res://RPGText/RPGText.tscn")


func Writer(Child: Node, Text: String, TextPosition: Vector2, TextSize: Vector2, TextSpeed: float, SetSpeed: Dictionary, SetPause: Dictionary, _Font: String, Sound: String, Interactable: bool, Skip: bool, DestroyTime: float, DefaultColor = Color.white, CallNode: Node = null, CallFunc: String = "", CallArgs: Array = []):
	var RPGText = Preload.instance()
	Child.add_child(RPGText)
	
	RPGText.bbcode_text = Text
	RPGText.rect_size = TextSize
	RPGText.rect_position = TextPosition
	
	RPGText.TextSpeed = TextSpeed
	RPGText.SetSpeed = SetSpeed
	RPGText.SetPause = SetPause
	
	if _Font != "": RPGText.set("custom_fonts/normal_font", load(_Font))
	RPGText.set("custom_colors/default_color", DefaultColor)
	if Sound != "": RPGText.get_node("Sound").stream = load(Sound)
	
	RPGText.Interactable = Interactable
	RPGText.Skip = Skip
	RPGText.DestroyTime = DestroyTime
	
	RPGText.CallNode = CallNode
	RPGText.CallFunc = CallFunc
	RPGText.CallArgs = CallArgs
	
	return RPGText


func Clear() -> void : for n in get_tree().get_nodes_in_group("RPGText"): n.queue_free()
