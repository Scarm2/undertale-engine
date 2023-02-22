extends Node

# Credits to JCW, snesmocha, Toby Fox and Scarm.

onready var PreloadedAttacks: Dictionary = {
	"Bone" : preload("res://Battle/Attacks/Bullets/Bone/Bone.tscn"),
	"BoneStab" : preload("res://Battle/Attacks/Bullets/BoneStab/BoneStab.tscn"),
	"GasterBlaster" : preload("res://Battle/Attacks/Bullets/GasterBlaster/GasterBlaster.tscn"),
	"Platform" : preload("res://Battle/Attacks/Bullets/Platform/Platform.tscn"),
}


func HeartBoxPos(HeartPos: Vector2, IdealBorder: Array) -> void:
	for n in get_tree().get_nodes_in_group("Player"): n.position = HeartPos
	Globals.IdealBorder = IdealBorder


func GasterBlaster(Child, Size, StartPos, IdealPos, IdealRot, Pause, Terminal, sColor = 0, ID = 0) -> Node:
	var GasterBlaster = PreloadedAttacks["GasterBlaster"].instance()
	GasterBlaster.ID = ID
	GasterBlaster.Sound = self
	
	GasterBlaster.IdealPos = IdealPos
	GasterBlaster.IdealRot = IdealRot
	
	GasterBlaster.Pause = Pause
	GasterBlaster.Terminal = Terminal
	
	GasterBlaster.position = StartPos
	GasterBlaster.get_node("Sprite").scale = Size
	
	GasterBlaster.sColor = sColor
	
	if StartPos == IdealPos: GasterBlaster.rotation_degrees = IdealRot
	else: GasterBlaster.rotation_degrees = 90
	
	Child.add_child(GasterBlaster)
	return GasterBlaster


func Bone(Child, Position, Direction, Height, Speed, BoneColor = 0, Angle = 0, ID = 0) -> Node:
	var Bone = PreloadedAttacks["Bone"].instance()
	Bone.ID = ID
	
	Bone.rect_size.y = Height
	
	Bone.rect_position = Position
	Bone.rect_rotation = Angle
	
	Bone.Direction = Direction
	Bone.Speed = Speed
	Bone.sColor = BoneColor
	
	
	Child.add_child(Bone)
	return Bone


func BoneStab(Child: Node, Direction: int, Height: int, Warning: float, Retain: float, sColor: int = 0, ID: int = 0) -> Node:
	var BoneStab = PreloadedAttacks["BoneStab"].instance()
	BoneStab.ID = ID
	BoneStab.Sound = self
	
	BoneStab.Direction = Direction
	BoneStab.Height = Height
	
	BoneStab.sColor = sColor
	
	BoneStab.Warning = Warning
	BoneStab.Retain = Retain
	
	Child.add_child(BoneStab)
	return BoneStab


func Platform(Child, Position, Direction, Height, Speed, PlatColor = 0, Angle = 0, ID = 0) -> Node:
	var Platform = PreloadedAttacks["Platform"].instance()
	Platform.ID = ID
	
	Platform.get_node("Bottom").rect_size.x = Height
	
	Platform.position = Position
	Platform.rotation_degrees = Angle
	
	Platform.Direction = Direction
	Platform.Speed = Speed
	Platform.PlatColor = PlatColor
	
	Child.add_child(Platform)
	return Platform

# Play sounds from the nodes.
func play(Sound: String, Pitch: float = 1, VolumeDB: float = 0, Looping: bool = false) -> void:
	get_node(Sound).pitch_scale = Pitch
	get_node(Sound).volume_db = VolumeDB
	get_node(Sound).stream.loop = Looping
	get_node(Sound).play()
