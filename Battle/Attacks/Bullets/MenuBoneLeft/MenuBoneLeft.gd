extends Node2D

var Destroy: bool = false
var Time: float = 0

func _process(delta: float) -> void:
	Time += delta
	
	position.x = -30 + abs(sin(10.0 * Time / PI)) * 105
	if position.x >= 64: Time -= delta * 0.72
	
	if Destroy and position.x <= -8: queue_free()
	
	for area in $MenuBone/HitBox.get_overlapping_areas(): if area.is_in_group("PlayerHitBox"): area.Damage(int(Globals.HP > 1), 0)
