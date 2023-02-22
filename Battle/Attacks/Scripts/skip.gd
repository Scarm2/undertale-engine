extends Node
signal EndAttack
func _ready() -> void: emit_signal("EndAttack")
