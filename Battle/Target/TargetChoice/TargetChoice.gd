extends AnimatedSprite

var Speed: int
var Limits: Dictionary

signal Miss
signal Hit


func _process(delta: float) -> void:
	position.x += Speed * delta
	if position.x > Limits["Right"] and Speed > 0 or position.x < Limits["Left"] and Speed < 0:
		emit_signal("Miss")
		queue_free()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and Speed != 0:
		Speed = 0
		play()
		emit_signal("Hit")
