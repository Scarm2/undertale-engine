extends Node2D

var State: int = 0

var IdealPos: float = 0


func _process(delta: float) -> void:
	match State:
		0:
			position.y -= 300.0 * delta
			if position.y <= 440:
				position.y = 440
				State = 1
		1:
			position.x -= 150.0 * delta
			if position.x <= IdealPos:
				position.x = IdealPos
				State = 2
		2:
			position.y += 300.0 * delta
			if position.y >= 480:
				queue_free()
	
	for area in $HitBox.get_overlapping_areas(): if area.is_in_group("PlayerHitBox"): if area.is_in_group("PlayerHitBox"): area.Damage(int(Globals.HP > 1), 0)
