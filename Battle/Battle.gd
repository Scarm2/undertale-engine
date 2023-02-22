extends Node2D

# Credits to: Scarm, snesmocha and Toby Fox.

var kr_t: float = 0
var kr_bonus: int = 0
var prevhp: int

func _ready() -> void:
	Globals.MaxHP = 92
	Globals.HP = Globals.MaxHP
	
	Globals.Items = [
		["Pie", "Butterscotch Pie", 99],
		["I.Noodles", "Instant Noodles", 90],
		["Steak", "Face Steak", 60],
		["L. Hero", "Legendary Hero", 40],
		["L. Hero", "Legendary Hero", 40],
		["SnowPiece", "Snowman Piece", 45],
		["SnowPiece", "Snowman Piece", 45],
		["Ab Quiche", "Abandoned Quiche", 34],
		["GlamBurg", "Glamburger", 27],
	]
	
	Globals.IdealBorder = [32, 607, 250, 390]
	
	yield(get_tree(), "idle_frame")
	$Music.play()
	$UI.EnableMenu()


func _process(delta: float) -> void:
	if Globals.KR > 40: Globals.KR = 40
	if Globals.KR >= Globals.HP: Globals.KR = Globals.HP - 1
	if Globals.KR > 0 and Globals.HP > 1:
		kr_t += delta
		if prevhp == Globals.HP:
			if Globals.Invinicibility >= 45: kr_bonus = [0, 1][randi() % 2]
			if Globals.Invinicibility >= 60: kr_bonus = [0, 1, 1][randi() % 3]
			if Globals.Invinicibility >= 75: kr_bonus = 1
			
			if (
				kr_t >= (1 + kr_bonus) / 30.0 and Globals.KR >= 40 or
				kr_t >= (2 + (kr_bonus * 2)) / 30.0 and Globals.KR >= 30 or
				kr_t >= (5 + (kr_bonus * 3)) / 30.0 and Globals.KR >= 20 or
				kr_t >= (15 + (kr_bonus * 5)) / 30.0 and Globals.KR >= 10 or
				kr_t >= (30 + (kr_bonus * 10)) / 30.0
			):
				kr_t = 0
				Globals.HP -= 1
				Globals.KR -= 1
			if Globals.HP <= 0: Globals.HP = 1
		prevhp = Globals.HP
	
	if Globals.HP <= 0:
		Globals.DeathPosition = $Heart.position.round()
		get_tree().change_scene("res://Battle/GameOver/GameOver.tscn")
