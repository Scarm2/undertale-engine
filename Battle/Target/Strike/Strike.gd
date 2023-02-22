extends Node2D
func _ready() -> void: $Animation.connect("animation_finished", self, "real")
func real(balls): queue_free()
