extends Node

var Heart
var Border
var Masked
var Unmasked
var Attacks
var Sound

signal EndAttack

func _ready() -> void:
	get_tree().call_group("SansBattle", "HeadAnimation", "BlueEye")
	get_tree().call_group("SansBattle", "BodyAnimation", "SlamDown", true)
	Sound.play("GasterBlaster", 1.4)
	Heart.Slam(1)
	yield(get_tree().create_timer(0.4), "timeout")
	Attacks.BoneStab(Masked, 1, 55, 0.2, 1)
	yield(get_tree().create_timer(0.2), "timeout")
	get_tree().call_group("SansBattle", "HeadAnimation", "NoEyes")
	get_tree().call_group("SansBattle", "BodyAnimation", "SlamUp", true)
	yield(get_tree().create_timer(0.4), "timeout")
	Heart.Mode(1)
	Sound.play("Bell")
	yield(get_tree().create_timer(0.4), "timeout")
	get_tree().call_group("SansBattle", "BodyAnimation", "SlamRight", true)
	Sound.play("GasterBlaster", 1.4)
	yield(get_tree().create_timer(0.4), "timeout")
	
	for n in 20:
		var h = 20
		var sn = floor(sin(deg2rad(n/3.0*180.0/PI))*28.0)
		Attacks.Bone(Masked, Vector2(240 - (n * 20), 230), 0, h + sn, 320)
		var y = 225 + 5 + h + sn + 39
		Attacks.Bone(Masked, Vector2(240 - (n * 20), y), 0, 390 - 5 - y, 320)
	
	yield(get_tree().create_timer(1.1), "timeout")
	get_tree().call_group("SansBattle", "BodyAnimation", "Default")
	
	Attacks.GasterBlaster(Unmasked, Vector2(2,2), Vector2(0,0), Vector2(Globals.IdealBorder[0] - 50, Globals.IdealBorder[2] + 20), 0, 0.333333333, 0.2666677)
	Attacks.GasterBlaster(Unmasked, Vector2(2,2), Vector2(640,480), Vector2(Globals.IdealBorder[1] + 50, Globals.IdealBorder[3] - 20), 180, 0.333333, 0.266667)
	Attacks.GasterBlaster(Unmasked, Vector2(2,2), Vector2(0,0), Vector2(Globals.IdealBorder[0] + 20, Globals.IdealBorder[2] - 60), 90, 0.333333, 0.266667)
	Attacks.GasterBlaster(Unmasked, Vector2(2,2), Vector2(640,480), Vector2(Globals.IdealBorder[1] - 20, Globals.IdealBorder[3] + 60), 270, 0.333333, 0.266667)
	yield(get_tree().create_timer(0.9), "timeout")
	Attacks.GasterBlaster(Unmasked, Vector2(2,2), Vector2(0,0), Vector2(Globals.IdealBorder[0] - 50, Globals.IdealBorder[2] - 50), 45, 0.333333, 0.266667)
	Attacks.GasterBlaster(Unmasked, Vector2(2,2), Vector2(640,0), Vector2(Globals.IdealBorder[1] + 50, Globals.IdealBorder[2] - 50), 135, 0.333333, 0.266667)
	Attacks.GasterBlaster(Unmasked, Vector2(2,2), Vector2(0,480), Vector2(Globals.IdealBorder[0] - 50, Globals.IdealBorder[3] + 50), -45, 0.333333, 0.266667)
	Attacks.GasterBlaster(Unmasked, Vector2(2,2), Vector2(640,480), Vector2(Globals.IdealBorder[1] + 50, Globals.IdealBorder[3] + 50), -135, 0.333333, 0.266667)
	yield(get_tree().create_timer(0.9), "timeout")
	Attacks.GasterBlaster(Unmasked, Vector2(2,2), Vector2(0,0), Vector2(Globals.IdealBorder[0] - 50, Globals.IdealBorder[2] + 20), 0, 0.333333, 0.266667)
	Attacks.GasterBlaster(Unmasked, Vector2(2,2), Vector2(640,480), Vector2(Globals.IdealBorder[1] + 50, Globals.IdealBorder[3] - 20), 180, 0.333333, 0.266667)
	Attacks.GasterBlaster(Unmasked, Vector2(2,2), Vector2(0,0), Vector2(Globals.IdealBorder[0] + 20, Globals.IdealBorder[2] - 60), 90, 0.333333, 0.266667)
	Attacks.GasterBlaster(Unmasked, Vector2(2,2), Vector2(640,480), Vector2(Globals.IdealBorder[1] - 20, Globals.IdealBorder[3] + 60), 270, 0.333333, 0.266667)
	yield(get_tree().create_timer(0.7), "timeout")
	Attacks.GasterBlaster(Unmasked, Vector2(3,3), Vector2(0,240), Vector2(Globals.IdealBorder[0] - 100, Globals.IdealBorder[2] + 80), 0, 0.666667, 0.5)
	Attacks.GasterBlaster(Unmasked, Vector2(3,3), Vector2(640,240), Vector2(Globals.IdealBorder[1] + 100, Globals.IdealBorder[2] + 80), 180, 0.666667, 0.5)
	
	yield(get_tree().create_timer(3), "timeout")
	get_tree().call_group("SansBattle", "HeadAnimation", "Default")
	emit_signal("EndAttack")
