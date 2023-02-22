extends Node

var Heart
var Border
var Masked
var Unmasked
var Attacks
var Sound

signal EndAttack

var spinny = false
var moment = 240

func _ready() -> void:
	Heart.Mode(1)
	yield(get_tree().create_timer(1), "timeout")
	get_tree().call_group("SansBattle", "BodyAnimation", "Shrug")
	yield(get_tree().create_timer(0.5), "timeout")
	get_tree().call_group("SansBattle", "HeadAnimation", "Wink")
	Sound.play("Bell")
	spinny = true
	yield(get_tree().create_timer(3), "timeout")
	
	var j = Tween.new()
	add_child(j)
	j.interpolate_property(self, "moment", 240, 0, 3, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	j.start()
	
	yield(j, "tween_all_completed")
	get_tree().call_group("SansBattle", "HeadAnimation", "Default")
	get_tree().call_group("SansBattle", "BodyAnimation", "Default")
	Border.rect_rotation = 0
	Globals.IdealBorder = [240, 405, 225, 390]
	
	Sound.play("GasterBlast2")
	var balls = ColorRect.new()
	balls.rect_size = Vector2(640, 480)
	add_child(balls)
	j.interpolate_property(balls, "modulate:a", 1, 0, 1)
	j.start()
	yield(j, "tween_all_completed")

	emit_signal("EndAttack")

func _process(delta: float) -> void:
	if spinny: Border.rect_rotation += delta * moment
