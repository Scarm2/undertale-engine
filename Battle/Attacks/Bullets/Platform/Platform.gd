extends Node2D

# Credits to JCW, Toby Fox and Scarm.

var Direction: int = 0
var Speed: int = 0
var PlatColor: int = 0
var ID: int = 0

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	match PlatColor:
		0:
			$Top.modulate = Color(0.18,0.37,0.18)
			
			$CollisionBoxFollow/Collision.disabled = false
			$CollisionBoxNoFollow/Collision.disabled = true
		1:
			$Top.modulate = Color(0.37,0.18,0.37)
			
			$CollisionBoxFollow/Collision.disabled = true
			$CollisionBoxNoFollow/Collision.disabled = false
	
	$Top.rect_size.x = $Bottom.rect_size.x
	
	$CollisionBoxFollow/Collision.position = Vector2(($Bottom.margin_left + $Bottom.margin_right) / 2.0, ($Bottom.margin_top + $Bottom.margin_bottom) / 2.0)
	$CollisionBoxFollow/Collision.shape.extents = $Bottom.rect_size / 2.0
	
	$CollisionBoxNoFollow/Collision.position = Vector2(($Bottom.margin_left + $Bottom.margin_right) / 2.0, ($Bottom.margin_top + $Bottom.margin_bottom) / 2.0)
	$CollisionBoxNoFollow/Collision.shape.extents = $Bottom.rect_size / 2.0
	
	var SetDir = deg2rad(Direction * 90)
	
	position += Vector2(cos(SetDir), sin(SetDir)) * delta * Speed
	
	if Direction == 0 and position.x > 640: queue_free()
	if Direction == 1 and position.y > 480: queue_free()
	if Direction == 2 and position.x < -$Bottom.rect_size.x: queue_free()
	if Direction == 3 and position.y < -$Bottom.rect_size.y: queue_free()
