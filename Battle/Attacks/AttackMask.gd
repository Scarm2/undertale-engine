extends Node2D

onready var Border = $"../../Border"


func _process(delta: float) -> void:
	$TopMask.show()
	$BottomMask.show()
	
	$TopMask.position = Border.get_node("TargetTopMask").global_position
	$TopMask.rotation = Border.get_node("TargetTopMask").global_rotation
	
	$BottomMask.position = Border.get_node("TargetBottomMask").global_position
	$BottomMask.rotation = Border.get_node("TargetBottomMask").global_rotation
