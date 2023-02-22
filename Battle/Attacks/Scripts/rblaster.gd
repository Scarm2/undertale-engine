extends Node

var Heart
var Border
var Masked
var Unmasked
var Attacks
var Sound

signal EndAttack


func _ready() -> void:
	randomize()
	Heart.Mode(1)
	yield(get_tree().create_timer(0.5), "timeout")
	loop()
	yield(get_tree().create_timer(8), "timeout")
	emit_signal("EndAttack")


func loop():
	for n in 15:
		var ang = randi() % 360
		var xy = Vector2(cos(ang), sin(ang))
		var xy1 = Vector2(xy.x * 300.0, xy.y * 400.0)
		var end = Vector2(xy.x * 200.0, xy.y * 200.0)
		end.x += Heart.position.x
		end.y += Heart.position.y
		xy1.x += Heart.position.x
		xy1.y += Heart.position.y
		if end.x < 50: end.x = 50
		if end.x > 590: end.x = 590
		if end.y < 40: end.y = 40
		if end.y > 440: end.y = 440
		var angle = rad2deg(Heart.position.angle_to_point(end))
		Attacks.GasterBlaster(Unmasked, Vector2(2,1), xy1, end, angle, 0.46666, 0.03333)
		yield(get_tree().create_timer(0.53333), "timeout")
