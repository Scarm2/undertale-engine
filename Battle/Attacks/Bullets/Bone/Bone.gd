extends NinePatchRect

# Credits to JCW, Toby Fox and Scarm.

var Direction: int = 0
var Speed: int = 0
var sColor: int = 0
var ID: int = 0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	match sColor:
		0: modulate = Color(1,1,1)
		1: modulate = Color(0,1,1)
		2: modulate = Color(1,0.37,0)
	
	rect_pivot_offset = rect_size / 2.0
	
	$HitBox/Collision.position = rect_size / 2.0
	$HitBox/Collision.shape.extents = $HitBox/Collision.position
	
	var SetDir = deg2rad(Direction * 90)
	
	rect_position += Vector2(cos(SetDir), sin(SetDir)) * delta * Speed
	
	if Direction == 0 and rect_position.x > 640: queue_free()
	if Direction == 1 and rect_position.y > 480: queue_free()
	if Direction == 2 and rect_position.x < -rect_size.x: queue_free()
	if Direction == 3 and rect_position.y < -rect_size.y: queue_free()
	
	for area in $HitBox.get_overlapping_areas():
		if area.is_in_group("PlayerHitBox"):
			for nodes in get_tree().get_nodes_in_group("Player"):
				match sColor:
					0: area.Damage(1, 3)
					1: if nodes.Movement != Vector2.ZERO: area.Damage(1, 3)
					2: if nodes.Movement == Vector2.ZERO: area.Damage(1, 3)
