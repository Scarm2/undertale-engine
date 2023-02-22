extends Node2D


func _process(delta: float) -> void:
	$HPBackground.margin_right = max(36, 36 + floor(Globals.MaxHP * 1.2))
	$HPOutline.margin_right = $HPBackground.margin_right + 2
	$HPBar.margin_right = max(36, 36 + floor(Globals.HP * 1.2))
	
	$KRBar.margin_right = (36 + (Globals.HP * 1.2))
	$KRBar.margin_left = max(36, floor((36 + (Globals.HP * 1.2)) - (Globals.KR * 1.2)))
	
	$KRMeter.position.x = $HPBackground.margin_right + 8
	
	$HPText.rect_position.x = $HPBackground.margin_right + 48
	$HPText.bbcode_text = str(Globals.HP).pad_zeros(len(str(Globals.MaxHP))) + " / " + str(Globals.MaxHP)
	
	if Globals.KR > 0: $HPText.modulate = $KRBar.color
	else: $HPText.modulate = Color.white
