extends RichTextLabel

# Credits to: Scarm and snesmocha.

var TextSpeed: float
var SetSpeed: Dictionary
var SetPause: Dictionary

var Interactable: bool
var Skip: bool
var DestroyTime: float

var CallNode: Node
var CallFunc: String
var CallArgs: Array

func _ready() -> void:
	visible_characters = 0
	if !Skip: $Timer.start(TextSpeed)


func TimerTimeout() -> void:
	if visible_characters < len(text):
		visible_characters += 1
		
		if text and text[visible_characters - 1] != " ": $Sound.play()
		
		if visible_characters in SetSpeed.keys() and !SetSpeed.empty(): TextSpeed = SetSpeed[visible_characters]
		
		if visible_characters in SetPause.keys() and !SetPause.empty(): $Timer.start(SetPause[visible_characters])
		else: $Timer.start(TextSpeed)


func _input(event: InputEvent) -> void:
	if visible_characters < len(text) and Interactable:
		if event.is_action_pressed("ui_cancel"): visible_characters = len(text)
	elif event.is_action_pressed("ui_accept") and Interactable: FunctionCall()


func _process(delta: float) -> void:
	if Skip: visible_characters = len(text)
	if visible_characters == len(text) and !Interactable:
		if DestroyTime > 0: DestroyTime -= min(delta, DestroyTime)
		else: FunctionCall()
	
	rect_pivot_offset = rect_size / 2.0


func FunctionCall():
	if CallNode != null:
		if CallArgs.size() > 0: CallNode.call_deferred(CallFunc, CallArgs)
		else: CallNode.call_deferred(CallFunc)
	if get_parent().is_in_group("SpeechBubble"): get_parent().queue_free()
	else: queue_free()
