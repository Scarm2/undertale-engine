extends Camera2D

var Intensity = 0
var ShakeTimer = 0


func Shake(Amount):
	Intensity = Amount


func _process(delta: float) -> void:
	if Intensity > 0: ShakeTimer += delta
	else: offset = Vector2(0,0)
	if ShakeTimer >= 1.0 / 30.0:
		ShakeTimer -= 1.0 / 30.0
		Intensity -= 1
		offset = Vector2(Intensity * [1, -1][randi() % 2], Intensity * [1, -1][randi() % 2])
