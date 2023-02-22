extends Node2D

var HeartShard = preload("res://Battle/GameOver/HeartShard/HeartShard.tscn")

func _ready() -> void:
	Globals.KR = 0
	$Heart.position = Globals.DeathPosition
	yield(get_tree().create_timer(20.0 / 30.0), "timeout")
	$HeartSplit.play()
	$Heart.texture = load("res://Textures/Heart/Split.png")
	yield(get_tree().create_timer(40.0 / 30.0), "timeout")
	$Heart.hide()
	$HeartShatter.play()
	
	for n in 6:
		var a = HeartShard.instance()
		a.position = $Heart.position
		a.linear_velocity = Vector2(rand_range(-360, 360), rand_range(-360, 360))
		add_child(a)
	
	yield(get_tree().create_timer(2), "timeout")
	
	RPGText.Writer(self, "[center]Press Z to go back.", Vector2(0,240), Vector2(640,96), 0.03, {}, {}, "res://Fonts/Resources/ComicSansBig.tres", "res://Audio/SansVoice.ogg", true, false, 0, Color.white, self, "medic")

func medic(): get_tree().change_scene("res://Battle/Battle.tscn")
