extends Node2D

onready var MenuBonePR = preload("res://Battle/Attacks/Bullets/MenuBone.tscn")

var Positions = [[140, 10], [300, 170], [450, 320], [620, 490]]

var Destroy = false
var Time = 0
var Alternate = 0


func _process(delta: float) -> void:
	if !Destroy:
		Time += delta
		if Time >= 0.6:
			Time = 0
			
			MenuBone(Positions[0 + Alternate])
			MenuBone(Positions[2 + Alternate])
			
			if Alternate == 0: Alternate = 1
			else: Alternate = 0
	elif get_child_count() <= 0:
		queue_free()


func MenuBone(IdealPos):
	var MenuBone = MenuBonePR.instance()
	
	MenuBone.set_script(load("res://Battle/Attacks/Bullets/MenuBoneBottom/MBBottomSystem.gd"))
	
	MenuBone.position = Vector2(IdealPos[0], 480)
	MenuBone.IdealPos = IdealPos[1]
	
	add_child(MenuBone)
