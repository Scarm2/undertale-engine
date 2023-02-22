extends Area2D

var DmgTimeout = 0


func Damage(HP, KR):
	if DmgTimeout > 1.0 / 30:
		DmgTimeout = 0
		Globals.HP -= HP
		Globals.KR += KR
		$Damaged.play()


func _process(delta: float) -> void: DmgTimeout += delta
