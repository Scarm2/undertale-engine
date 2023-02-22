extends Sprite

var Fade: bool = false

signal RemoveTargets

signal Hit
signal Miss

func _ready() -> void:
	randomize()
	var r: int = randi() % 2
	
	var TargetChoice: AnimatedSprite = load("res://Battle/Target/TargetChoice/TargetChoice.tscn").instance()
	TargetChoice.connect("Hit", self, "Hit")
	TargetChoice.connect("Miss", self, "Miss")
	connect("RemoveTargets", TargetChoice, "queue_free")
	
	if r == 0:
		TargetChoice.position.x = -274
		TargetChoice.Speed = 360
	if r == 1:
		TargetChoice.position.x = 306
		TargetChoice.Speed = -360
	
	TargetChoice.Limits = {"Left" : -290, "Right" : 290}
	add_child(TargetChoice)

func _process(delta: float) -> void:
	if Fade:
		modulate.a -= 0.08 * delta * 30
		scale.x -= 0.06 * delta * 30
		if scale.x < 0.08: queue_free()


func Fade():
	Fade = true
	emit_signal("RemoveTargets")


func Hit():
	var Strike = load("res://Battle/Target/Strike/Strike.tscn").instance()
	Strike.position = Vector2(320, 144)
	get_parent().add_child(Strike)
	emit_signal("Hit")
func Miss():
	Fade = true
	emit_signal("Miss")
