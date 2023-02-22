extends Node

var Heart
var Border
var Masked
var Unmasked
var Attacks
var Sound

signal EndAttack


func _ready() -> void:
	Heart.Mode(2)
	for n in 8:
		Attacks.Bone(Masked, Vector2(128 - n * 120, 256), 0, 95, 180)
		Attacks.Bone(Masked, Vector2(128 - n * 120, 365), 0, 20, 180)
		Attacks.Bone(Masked, Vector2(503 + n * 120, 256), 2, 95, 180)
		Attacks.Bone(Masked, Vector2(503 + n * 120, 365), 2, 20, 180)
	yield(get_tree().create_timer(6.4), "timeout")
	emit_signal("EndAttack")
