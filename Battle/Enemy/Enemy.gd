extends Node2D

var HitState = 0
var HitTimer = 0

var SlideSpeed = 0

var CurrentPos = position.x
var BoxTopPos = true

signal HitFinished


func Hit():
	CurrentPos = position.x
	
	HitState = 1
	HitTimer = 0
	
	$"../Attacks".AttackNum += 1


func _process(delta: float) -> void:
	if BoxTopPos: position.y = Globals.IdealBorder[2] - 16.0
	
	if HitState != 0: HitTimer += delta
	match HitState:
		1:
			position.x = CurrentPos - sin(HitTimer * 4) * 100
			if HitTimer >= 0.4:
				position.x = CurrentPos - 100
				HitState = 2
				HitTimer = 0
				yield(get_tree().create_timer(0.6), "timeout")
				MissText()
		2:
			if HitTimer >= 1.1:
				HitState = 3
				HitTimer = 0
		3:
			position.x = CurrentPos - cos(HitTimer * 4) * 100
			if HitTimer >= 0.4:
				position.x = CurrentPos
				HitState = 0
				HitTimer = 0
				$"../Attacks".Start(true)
				emit_signal("HitFinished")
				$Dialogue.Start()


func MissText(SetText = "MISS", SetColor = Color8(192, 192, 192), Position = Vector2(272, 50)):
	var TweenJumper = Tween.new()
	var Text = RichTextLabel.new()
	
	Text.rect_position = Position
	Text.rect_size = Vector2(640, 480)
	Text.bbcode_text = SetText
	Text.scroll_active = false
	Text.rect_clip_content = false
	Text.modulate = SetColor
	
	Text.set("custom_fonts/normal_font", load("res://Fonts/Resources/Damage.tres"))
	
	add_child(TweenJumper)
	owner.add_child(Text)
	
	TweenJumper.interpolate_property(Text, "rect_position:y", Text.rect_position.y, Text.rect_position.y - 25, 0.3, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	TweenJumper.start()
	yield(TweenJumper, "tween_all_completed")
	TweenJumper.interpolate_property(Text, "rect_position:y", Text.rect_position.y, Text.rect_position.y + 25, 0.3, Tween.TRANS_CUBIC, Tween.EASE_IN)
	TweenJumper.start()
	yield(TweenJumper, "tween_all_completed")
	yield(get_tree().create_timer(0.9), "timeout")
	TweenJumper.queue_free()
	Text.queue_free()
