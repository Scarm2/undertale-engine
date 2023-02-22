extends RigidBody2D


func _ready() -> void:
	$Sprite.play()
	#if !$Sprite/VisibilityNotifier2D.is_on_screen(): queue_free()
