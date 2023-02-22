extends BackBufferCopy

var AttackNum = 0
var AttackList = ["intro", "bonegap", "rblaster", "brain damage"]

signal RunAttack


func Start(WaitForSignal = false, CustomAttack = ""):
	for n in get_tree().get_nodes_in_group("MenuBone"): n.Destroy = true
	
	if CustomAttack == "":
		match AttackNum:
			0: $AttackFunctions.HeartBoxPos(Vector2(320, 304), [240, 405, 225, 390])
			1: $AttackFunctions.HeartBoxPos(Vector2(320, 376), [132, 507, 250, 390])
			2: $AttackFunctions.HeartBoxPos(Vector2(320, 304), [120, 525, 185, 390])
			3: $AttackFunctions.HeartBoxPos(Vector2(320, 304), [320 - 14, 320 + 14, 225, 390])
	
	if !WaitForSignal: call_deferred("emit_signal", "RunAttack")
	
	yield(self, "RunAttack")
	yield($"../Border", "ResizeFinished")
	
	var AttackScn = Node.new()
	
	if CustomAttack != "": AttackScn.set_script(load(CustomAttack))
	else: AttackScn.set_script(load("res://Battle/Attacks/Scripts/" + AttackList[AttackNum] + ".gd"))
	
	var VarDicts = {
		"Border" : $"../Border",
		"Heart" : $"../Heart",
		"UI" : $"../UI",
		"Dialogue" : $"../Enemy/Dialogue",
		"Masked" : $Masked,
		"Unmasked" : $Unmasked,
		"Attacks" : $AttackFunctions,
		"Sound" : $AttackFunctions,
	}
	var KeyValues = [VarDicts.keys(), VarDicts.values()]
	
	for n in len(VarDicts): if KeyValues[0][n] in AttackScn: AttackScn.set(KeyValues[0][n], KeyValues[1][n])
	
	AttackScn.connect("EndAttack", self, "End")
	
	AttackScn.add_to_group("Attack")
	
	add_child(AttackScn)


func End():
	for n in get_tree().get_nodes_in_group("Player"): n.Mode(0)
	for n in $Masked.get_children(): n.queue_free()
	for n in $Unmasked.get_children(): n.queue_free()
	for n in get_tree().get_nodes_in_group("Attack"): n.queue_free()
	
	Globals.IdealBorder = [32, 607, 250, 390]
	
	#if AttackNum >= 0:
	#	var MenuBoneLeft = load("res://Battle/Attacks/Bullets/MenuBoneLeft/MenuBoneLeft.tscn").instance()
	#	MenuBoneLeft.position = Vector2(-10, 270)
	#	add_child(MenuBoneLeft)
	#if AttackNum >= 0:
	#	var MenuBoneBottom = load("res://Battle/Attacks/Bullets/MenuBoneBottom/MenuBoneBottom.tscn").instance()
	#	MenuBoneBottom.Positions = [[140, 10], [300, 170], [450, 320], [620, 490]]
	#	add_child(MenuBoneBottom)

	yield($"../Border", "ResizeFinished")
	
	$"../UI".EnableMenu()
