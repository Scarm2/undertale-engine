extends NinePatchRect

# Credits to JCW, Toby Fox and Scarm.

onready var BoneV: Texture = preload("res://Textures/BoneV.png")
onready var BoneH: Texture = preload("res://Textures/BoneH.png")

var ID: int = 0
var Sound: Node

var Warning: float = 0
var Direction: int = 0

var Height: float = 0
var sColor: int = 0

var Retain: float = 0
var Racket: int = 3
var RacketTimer: float = 0
var Continue: int = 0

var IdealPos: Vector2 = Vector2(0,0)
var StartPos: Vector2 = Vector2(0,0)

func _ready() -> void:
	Sound.play("Warning")
	match Direction:
		0,2:
			texture = BoneH
			
			patch_margin_left = 6
			patch_margin_top = 0
			patch_margin_right = 6
			patch_margin_bottom = 0
			
			margin_top = Globals.IdealBorder[2]
			margin_bottom = Globals.IdealBorder[3]
			
			$Warning.margin_top = 8
			$Warning.margin_bottom = rect_size.y - 8
			
			
		1,3:
			texture = BoneV
			
			patch_margin_left = 0
			patch_margin_top = 6
			patch_margin_right = 0
			patch_margin_bottom = 6
			
			margin_left = Globals.IdealBorder[0]
			margin_right = Globals.IdealBorder[1]
			
			$Warning.margin_left = 8
			$Warning.margin_right = rect_size.x - 8
			
			IdealPos.x = rect_position.x
	match Direction:
		0:
			margin_left = Globals.IdealBorder[1]
			margin_right = Globals.IdealBorder[1] + 8 + Height
			
			$Warning.margin_left = -Height - 8
			$Warning.margin_right = -8
			
			IdealPos = Vector2(rect_position.x - Height - 8, rect_position.y)
		1:
			margin_top = Globals.IdealBorder[3]
			margin_bottom = Globals.IdealBorder[3] + 8 + Height
			
			$Warning.margin_top = -Height - 8
			$Warning.margin_bottom = -8
			
			IdealPos = Vector2(rect_position.x, rect_position.y - Height - 8)
		2:
			margin_left = Globals.IdealBorder[0] - 8 - Height
			margin_right = Globals.IdealBorder[0]
			
			$Warning.margin_left = rect_size.x + 8
			$Warning.margin_right = rect_size.x + Height + 8
			
			IdealPos = Vector2(rect_position.x + Height + 8, rect_position.y)
		3:
			margin_top = Globals.IdealBorder[2] - 8 - Height
			margin_bottom = Globals.IdealBorder[2]
			
			$Warning.margin_top = rect_size.y + 8
			$Warning.margin_bottom = rect_size.y + Height + 8
			
			IdealPos = Vector2(rect_position.x, rect_position.y + Height + 8)
	StartPos = rect_position

func _process(delta: float) -> void:
	match sColor:
		0: self_modulate = Color(1,1,1)
		1: self_modulate = Color(0,1,1)
		2: self_modulate = Color(1,0.37,0)
	
	$HitBox/Collision.position = rect_size / 2.0
	$HitBox/Collision.shape.extents = $HitBox/Collision.position
	
	if Warning > 0: Warning -= min(delta, Warning)
	else:
		if $Warning.visible:
			Sound.play("SpearRise")
			$Warning.hide()
		var Speed = Height * 10
		
		match Continue:
			0:
				match Direction:
					0: rect_position.x -= floor((Height / 3)) * delta * 30
					1: rect_position.y -= floor((Height / 3)) * delta * 30
					2: rect_position.x += floor((Height / 3)) * delta * 30
					3: rect_position.y += floor((Height / 3)) * delta * 30
				if (
					rect_position.x < IdealPos.x and Direction == 0 or
					rect_position.y < IdealPos.y and Direction == 1 or
					rect_position.x > IdealPos.x and Direction == 2 or
					rect_position.y > IdealPos.y and Direction == 3
				):
					rect_position = IdealPos
					Continue = 1
			1:
				Retain -= min(delta, Retain)
				RacketTimer += delta
				
				var rr = (randf() * Racket - randf() * Racket)
				var rr2 = (randf() * Racket - randf() * Racket)
				
				if Racket > 0 and RacketTimer > 1.0 / 30.0:
					RacketTimer -= 1.0 / 30.0
					Racket -= 1
					
				rect_position = Vector2(IdealPos.x + rr, IdealPos.y + rr2)
				
				if Retain <= 0: Continue = 2
			2:
				match Direction:
					0: rect_position.x += floor((Height / 4)) * delta * 30
					1: rect_position.y += floor((Height / 4)) * delta * 30
					2: rect_position.x -= floor((Height / 4)) * delta * 30
					3: rect_position.y -= floor((Height / 4)) * delta * 30
				if (
					rect_position.x > StartPos.x and Direction == 0 or
					rect_position.y > StartPos.y and Direction == 1 or
					rect_position.x < StartPos.x and Direction == 2 or
					rect_position.y < StartPos.y and Direction == 3
				): queue_free()
	
	for area in $HitBox.get_overlapping_areas():
		if area.is_in_group("PlayerHitBox"):
			for nodes in get_tree().get_nodes_in_group("Player"):
				match sColor:
					0: area.Damage(1, 3)
					1: if nodes.Movement != Vector2.ZERO: area.Damage(1, 3)
					2: if nodes.Movement == Vector2.ZERO: area.Damage(1, 3)
