extends KinematicBody2D

var Mode = 0
var Speed = 150

var Movement = Vector2(0,0)

var Gravity = 0
var DownSpeed = 0
var MaxFallSpeed = 750
var SlamFall = Vector2(0,0)

var Slammed = false
var SlamDamage = false

func Mode(SetMode, Rotation = 1):
	match SetMode:
		1: $Sprite.modulate = Color.red
		2: $Sprite.modulate = Color(0, 0.25, 1)
	
	Gravity = 0
	DownSpeed = 0
	Mode = SetMode
	Movement = Vector2(0,0)
	$Sprite.rotation_degrees = Rotation * 90


func Slam(Direction):
	Mode(2, Direction)
	Slammed = true
	Movement = Vector2(cos($Sprite.rotation), sin($Sprite.rotation)) * MaxFallSpeed
	SlamFall = Movement


func _physics_process(delta: float) -> void:
	var GroundDir = {0.0 : Vector2.LEFT, 90.0 : Vector2.UP, 180.0 : Vector2.RIGHT, 270.0 : Vector2.DOWN}
	var FloorDir = {0.0 : Input.is_action_pressed("ui_left"), 90.0 : Input.is_action_pressed("ui_up"), 180.0 : Input.is_action_pressed("ui_right"), 270.0 : Input.is_action_pressed("ui_down")}
	var MoveInput = Vector2(int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")), int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up")))
	
	var TrueSpeed = Speed if !Input.is_action_pressed("ui_cancel") else Speed / 2.0
	
	match Mode:
		1: Movement = MoveInput * TrueSpeed
		2:
			if is_on_floor():
				if FloorDir[round($Sprite.rotation_degrees)]: Movement -= Vector2(cos($Sprite.rotation), sin($Sprite.rotation)) * 180
				
				if Slammed:
					if abs(SlamFall.x) >= 330.0: get_tree().call_group("Camera", "Shake", floor(abs(SlamFall.x / 30.0 / 3.0)))
					if abs(SlamFall.y) >= 330.0: get_tree().call_group("Camera", "Shake", floor(abs(SlamFall.y / 30.0 / 3.0)))
					$HitBox.Damage(int(SlamDamage), 0)
					$Slam.play()
					Slammed = false
				
			else:
				Movement += Vector2(cos($Sprite.rotation), sin($Sprite.rotation)) * Gravity * delta
				SlamFall = Movement
				
			if $Sprite.rotation_degrees == 0.0:
				Movement.x = min(MaxFallSpeed, Movement.x)
				DownSpeed = Movement.x
				if !FloorDir[round($Sprite.rotation_degrees)] and Movement.x < -30: Movement.x = -30
			if $Sprite.rotation_degrees == 90.0:
				Movement.y = min(MaxFallSpeed, Movement.y)
				DownSpeed = Movement.y
				if !FloorDir[round($Sprite.rotation_degrees)] and Movement.y < -30: Movement.y = -30
			if $Sprite.rotation_degrees == 180.0:
				Movement.x = max(-MaxFallSpeed, Movement.x)
				DownSpeed = -Movement.x
				if !FloorDir[round($Sprite.rotation_degrees)] and Movement.x > 30: Movement.x = 30
			if $Sprite.rotation_degrees == 270.0:
				Movement.y = max(-MaxFallSpeed, Movement.y)
				DownSpeed = -Movement.y
				if !FloorDir[round($Sprite.rotation_degrees)] and Movement.y > 30: Movement.y = 30
			
			if DownSpeed < 240 and DownSpeed > 15: Gravity = 540
			if DownSpeed <= 15 and DownSpeed > -30: Gravity = 180
			if DownSpeed <= -30 and DownSpeed > -120: Gravity = 450
			if DownSpeed <= -120: Gravity = 180
			
			if $Sprite.rotation_degrees in [90.0, 270.0]: Movement.x = MoveInput.x * TrueSpeed
			if $Sprite.rotation_degrees in [0.0, 180.0]: Movement.y = MoveInput.y * TrueSpeed
	
	Movement = move_and_slide(Movement, GroundDir[round($Sprite.rotation_degrees)])
