extends Node2D

# Credits to: JCW, Toby Fox and Scarm.

var ID: int = 0
var Sound: Node

var Continue: int = 0

var IdealPos: Vector2 = Vector2(0,0)
var IdealRot: int = 90

var Pause: float = 0
var BTimer: float = 0
var Terminal: float = 0

var LaserSize: float = 0
var SinerSize: float = 0

var Speed: float = 0

var sColor: int = 0


func _ready() -> void:
	randomize()
	Sound.play("GasterBlaster", 1.2)


func _process(delta: float) -> void:
	match sColor:
		0: modulate = Color(1,1,1)
		1: modulate = Color(0,1,1)
		2: modulate = Color(1,0.37,0)
	
	match Continue:
		0:
			position.x += floor((IdealPos.x - position.x) / 3.0) * delta * 30
			position.y += floor((IdealPos.y - position.y) / 3.0) * delta * 30
			
			if position.x < IdealPos.x: position.x += delta * 30.0
			if position.y < IdealPos.y: position.y += delta * 30.0
			
			if position.x > IdealPos.x: position.x -= delta * 30.0
			if position.y > IdealPos.y: position.y -= delta * 30.0
			
			if abs((position.x - IdealPos.x)) < 3.0: position.x = IdealPos.x
			if abs((position.y - IdealPos.y)) < 3.0: position.y = IdealPos.y
			
			rotation_degrees += floor((IdealRot - rotation_degrees) / 3.0) * delta * 30
			
			if rotation_degrees < IdealRot: rotation_degrees += delta * 30.0
			if rotation_degrees > IdealRot: rotation_degrees -= delta * 30.0
			
			if abs((rotation_degrees - IdealRot)) < 3.0: rotation_degrees = IdealRot
			if abs((position.x - IdealPos.x)) < 3.0 and abs((position.y - IdealPos.y)) < 3.0 and abs((rotation_degrees - IdealRot)) < 3.0: Continue = 2
		2:
			if Pause > 0: Pause -= min(delta, Pause)
			else:
				Continue = 3
				Pause = 0.1
				$Sprite/Animation.play("Fire")
		3:
			if Pause > 0: Pause -= min(delta, Pause)
			else:
				Sound.play("GasterBlast", 1.2)
				Sound.play("GasterBlast2", 1.2)
				$Laser.show()
				if $Sprite.scale.y >= 2: get_tree().call_group("Camera", "Shake", 5.0)
				Continue = 4
		4:
			position -= Vector2(cos(rotation), sin(rotation)) * delta * Speed
			if $Sprite/VisibilityNotifier2D.is_on_screen(): Speed += (delta * 300.0) * 10.0
			else: Speed = 0
	
	if $Laser.visible:
		BTimer += delta
		if BTimer < 4.0 / 30.0: LaserSize += floor(35.0 * $Sprite.scale.y / 4.0) * delta * 30.0
		if BTimer >= 4.0 / 30.0 and BTimer < 4.0 / 30.0 + delta: LaserSize = 35.0 * $Sprite.scale.y
		if BTimer > 5.0 / 30.0 + Terminal:
			LaserSize *= pow(0.8, delta * 30.0)
			$Laser.modulate.a -= 0.1 * delta * 30
			if LaserSize <= 2: queue_free()
		SinerSize = sin(deg2rad(BTimer * 30.0 / 1.5 * 180.0 / PI)) * LaserSize / 4.0
	
	var rr = (randf() * 2 - randf() * 2)
	var rr2 = (randf() * 2 - randf() * 2)
	
	$Laser.position = Vector2((70.0 * $Sprite.scale.y / 2.0) + rr, rr2)
	$Laser.scale = Vector2(1000, (LaserSize + SinerSize) / 16.0)
	
	$LaserTop.position = Vector2((60.0 * $Sprite.scale.y / 2.0) + rr, rr2)
	$LaserTop.scale = Vector2((10.0 * $Sprite.scale.y / 2.0) / 16.0, (LaserSize / 1.25 + SinerSize) / 16.0)
	$LaserTop.modulate.a = $Laser.modulate.a
	$LaserTop.visible = $Laser.visible
	
	$LaserTop2.position = Vector2((50.0 * $Sprite.scale.y / 2.0) + rr, rr2)
	$LaserTop2.scale = Vector2((20.0 * $Sprite.scale.y / 2.0) / 16.0, (LaserSize / 2.0 + SinerSize) / 16.0)
	$LaserTop2.modulate.a = $Laser.modulate.a
	$LaserTop2.visible = $Laser.visible
	
	$LaserHitBox.position = Vector2((70.0 * $Sprite.scale.y / 2.0) + rr, rr2)
	$LaserHitBox.scale = Vector2(1000, (LaserSize * 3.0 / 4.0) / 16.0)
	$LaserHitBox.modulate.a = $Laser.modulate.a
	$LaserHitBox.visible = $Laser.visible
	
	
	for area in $LaserHitBox/HitBox.get_overlapping_areas():
		if area.is_in_group("PlayerHitBox"):
			for nodes in get_tree().get_nodes_in_group("Player"):
				if BTimer < 5.0 / 30.0 + Terminal and $Laser.visible:
					match sColor:
						0: area.Damage(1, 5)
						1: if nodes.Movement != Vector2.ZERO: area.Damage(1, 5)
						2: if nodes.Movement == Vector2.ZERO: area.Damage(1, 5)
