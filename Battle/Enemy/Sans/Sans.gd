extends Node2D

var Bounce: int = 1
var Siner: float
var Offset: Vector2
var SlamEnabled: bool = false

func _process(delta: float) -> void:
	Siner = Siner + delta if Bounce != 0 else 0
	match Bounce:
		0:
			Siner = 0
			Offset = Vector2(0,0)
		1: Offset = Vector2(cos((Siner * 30) / 6), sin((Siner * 30) / 3))
		2: Offset = Vector2(0, sin((Siner * 30) / 15) * 4)
		3: Offset = Vector2(0, sin((Siner * 30) / 18) * 2)
	if SlamEnabled: $Body.position = $Legs/Pivot.position
	else: $Body.position = $Legs/Pivot.position + Vector2(Offset.x, Offset.y / 1.5)
	$Head.position = $Legs/Pivot.position + $Body/Pivot.position + Offset


func HeadAnimation(SetAnimation: String): $Head/Animation.play(SetAnimation)
func BodyAnimation(SetAnimation: String, SetSlam: bool = false, SlamSpeed: float = 1.0):
	SlamEnabled = SetSlam
	$Body/Animation.play(SetAnimation)
	$Body/Animation.playback_speed = SlamSpeed if SlamEnabled else 1.0
func LegsAnimation(SetAnimation: String): $Legs/Animation.play(SetAnimation)
