extends Node2D

# Credits to: Scarm and snesmocha.

var DefaultTextFont: String = "res://Fonts/Resources/MainMono.tres"
var DefaultTextSound: String = "res://Audio/BattleText.ogg"

var InfoText: Array

var Buttons: Array = [[], []]

var VerticalPos: Array = [Vector2(72, 289), Vector2(72, 323), Vector2(72, 356)]
var ActPos: Array = [Vector2(72, 289), Vector2(340, 289), Vector2(72, 322), Vector2(340, 322), Vector2(72, 353), Vector2(340, 353)]
var ItemPos: Array = [Vector2(72, 289), Vector2(312, 289), Vector2(72, 323),Vector2(312, 323)]

var ButtonSelection: int = 0
var MenuSelection: int = 0

var MenuMode: Dictionary = {"Buttons" : false, "VerticalSelection" : false, "Act" : false, "Item" : false}


var Enemy: Array = ["Sans"]
var EnemyAct: Array = [["Check"]]

var SpareOptions: Array = ["Spare"]


var MenuSize: int = 0

var FightEnemy: int = 0

var ActEnemy: int = 0
var ActTextIndex: int = 0

var ItemPage: int = 0


func Writer(Text: String, TextSpeed: float, SetSpeed: Dictionary, SetPause: Dictionary, CallNode: Node = null, CallFunc: String = "", CallArgs: Array = []) -> void:
	RPGText.Writer(self, Text, Vector2(48, 272), Vector2(544, 96), TextSpeed, SetSpeed, SetPause, DefaultTextFont, DefaultTextSound, true, false, 0, Color.white, CallNode, CallFunc, CallArgs)
func InstaWriter(Text: String, CallNode: Node = null, CallFunc: String = "", CallArgs: Array = []) -> void:
	RPGText.Writer(self, Text, Vector2(48, 272), Vector2(544, 96), 0, {}, {}, DefaultTextFont, "", true, true, 0, Color.white, CallNode, CallFunc, CallArgs)


func ButtonSet() -> void:
	Buttons = [[], []]
	for n in get_tree().get_nodes_in_group("UIButtons"):
		Buttons[0].append(n.get_node("Sprite/HeartPos").global_position)
		Buttons[1].append(n.get_node("Animation"))


func _ready() -> void:
	ButtonSet()
	
	InfoText = ["* A Second thing happened...", 0.03, {}, {}]


func EnableMenu(Skip = false) -> void:
	if !Skip: Writer(InfoText[0], InfoText[1], InfoText[2], InfoText[3])
	else: InstaWriter(InfoText[0])
	
	MenuSelection = 0
	
	MenuMode["Buttons"] = true
	Buttons[1][ButtonSelection].play("Highlight")


func MenuAction() -> void:
	var MenuFunctions: Dictionary = {0 : "MenuFight", 1 : "MenuAct", 2 : "MenuItem", 3 : "MenuMercy"}
	var MenuTexts: Dictionary = {0 : Enemy, 1 : Enemy, 2 : Globals.Items, 3 : SpareOptions}
	MenuSize = MenuTexts[ButtonSelection].size()
	match ButtonSelection:
		0,1,3:
			InstaWriter(VerticalMenuText(MenuTexts[ButtonSelection]), self, MenuFunctions[ButtonSelection])
			MenuMode["VerticalSelection"] = true
			
		2:
			if Globals.Items.empty(): EnableMenu(true)
			else:
				ItemPage = MenuSelection / 4
				InstaWriter(ItemText(), self, MenuFunctions[ButtonSelection])
				MenuMode["Item"] = true

func MenuClear() -> void:
	RPGText.Clear()
	
	yield(get_tree(), "idle_frame")
	
	for n in Buttons[1].size(): Buttons[1][n].play("Default")
	for n in get_tree().get_nodes_in_group("Player"): n.position = -Vector2(640, 480) * 2

func MenuFight() -> void:
	MenuMode["VerticalSelection"] = false
	MenuClear()
	$MenuSelect.play()
	
	FightEnemy = MenuSelection
	MenuSelection = 0
	
	var Target = load("res://Battle/Target/Target.tscn").instance()
	Target.position = Vector2(320, 320)
	for n in get_tree().get_nodes_in_group("Enemy"): n.connect("HitFinished", Target, "Fade")
	Target.connect("Hit", get_tree().get_nodes_in_group("Enemy")[FightEnemy], "Hit")
	Target.connect("Miss", get_tree().get_nodes_in_group("Enemy")[FightEnemy], "MissText")
	Target.connect("Miss", $"../Attacks", "Start")
	add_child(Target)

func MenuAct() -> void:
	MenuMode["VerticalSelection"] = false
	
	MenuSize = EnemyAct[MenuSelection].size()
	InstaWriter(ActText(EnemyAct[MenuSelection]), self, "MenuActText")
	
	ActEnemy = MenuSelection
	MenuSelection = 0
	
	MenuMode["Act"] = true
	$MenuSelect.play()

func MenuActText() -> void:
	MenuMode["Act"] = false
	MenuClear()
	$MenuSelect.play()
	
	var Text: Array
	
	match ActEnemy:
		0: match MenuSelection:
			0: Text = [["* SANS 1 ATK 1 DEF\n* Easiest enemy.\n* Can only deal 1 damage.", 0.03, {}, {}],]
	
	var Action: String = "MenuActText" if ActTextIndex < len(Text) - 1 else "SkipAttack"
	Writer(Text[ActTextIndex][0], Text[ActTextIndex][1], Text[ActTextIndex][2], Text[ActTextIndex][3], self, Action)
	ActTextIndex += 1

func MenuItem() -> void:
	MenuMode["Item"] = false
	MenuClear()
	$MenuSelect.play()
	for n in get_tree().get_nodes_in_group("Player"): n.get_node("HitBox/Heal").play()
	
	var HealText: String
	var ExtraText: String
	
	match Globals.Items[MenuSelection][1]:
		"Instant Noodles": ExtraText = "* They're better dry.\n"
		"Legendary Hero": ExtraText = "* ATTACK increased by 4!\n"
	
	if Globals.HP + Globals.Items[MenuSelection][2] <= Globals.MaxHP:
		Globals.HP += int(Globals.Items[MenuSelection][2])
		HealText = "* You recovered " + str(Globals.Items[MenuSelection][2]) + " HP!"
	else:
		Globals.HP = Globals.MaxHP
		HealText = "* Your HP has been maxed out."
	
	Writer("* You ate the " + Globals.Items[MenuSelection][1] + ".\n" + ExtraText + HealText, 0.03, {}, {}, self, "SkipAttack")
	
	Globals.Items.remove(MenuSelection)

func MenuMercy() -> void:
	MenuMode["VerticalSelection"] = false
	MenuClear()
	SkipAttack()
	$MenuSelect.play()


func SkipAttack():
	yield(get_tree(), "idle_frame")
	ActTextIndex = 0
	$"../Attacks".Start()




func _input(event: InputEvent) -> void:
	var MenuInput: Vector2 = Vector2(
		int(event.is_action_pressed("ui_right")) - int(event.is_action_pressed("ui_left")),
		int(event.is_action_pressed("ui_down")) - int(event.is_action_pressed("ui_up"))
	)
	
	if MenuMode["Buttons"]:
		if MenuInput.x:
			Buttons[1][ButtonSelection].play("Default")
			ButtonSelection = posmod(ButtonSelection + MenuInput.x, Buttons[0].size())
			Buttons[1][ButtonSelection].play("Highlight")
			$MenuCursor.play()
		elif event.is_action_pressed("ui_accept"):
			MenuMode["Buttons"] = false
			RPGText.Clear()
			MenuAction()
			$MenuSelect.play()
	if MenuMode["VerticalSelection"]:
		if MenuInput.y: MenuSelection = posmod(MenuSelection + MenuInput.y, MenuSize)
		elif event.is_action_pressed("ui_cancel"):
			MenuMode["VerticalSelection"] = false
			RPGText.Clear()
			EnableMenu()
	if MenuMode["Act"]:
		if MenuInput:
			MenuSelection = posmod(MenuSelection + MenuInput.x, MenuSize)
			MenuSelection = posmod(MenuSelection + (MenuInput.y * 2), MenuSize)
		elif event.is_action_pressed("ui_cancel"):
			MenuMode["Act"] = false
			MenuSelection = 0
			RPGText.Clear()
			MenuAction()
	if MenuMode["Item"]:
		if MenuInput:
			MenuSelection = posmod(MenuSelection + MenuInput.x, MenuSize)
			MenuSelection = posmod(MenuSelection + (MenuInput.y * 2), MenuSize)
			MenuSize = Globals.Items.size()
			ItemPage = MenuSelection / 4
			RPGText.Clear()
			InstaWriter(ItemText(), self, "MenuItem")
		elif event.is_action_pressed("ui_cancel"):
			MenuMode["Item"] = false
			RPGText.Clear()
			EnableMenu()

func _process(delta: float) -> void:
	for n in get_tree().get_nodes_in_group("Player"):
		if MenuMode["Buttons"]: n.position = Buttons[0][ButtonSelection]
		if MenuMode["VerticalSelection"]: n.position = VerticalPos[MenuSelection]
		if MenuMode["Act"]: n.position = ActPos[MenuSelection]
		if MenuMode["Item"]: n.position = ItemPos[MenuSelection % 4]




func VerticalMenuText(Text: Array) -> String:
	var SetText: String = ""
	
	for Element in range(0, len(Text)):
		SetText += "   * " + Text[Element] + "\n"
	
	return SetText

func ActText(Text: Array) -> String:
	var SetText: String = ""
	var Line: float = 0
	
	for Element in range(0, len(Text)):
		SetText += "   * " + Text[Element]
		for i in range(0, 12 - len(Text[Element])): SetText += " "
		SetText += ""
		if (Element + 1) % 2 == 0:
			SetText += "\n"
			Line += 1
	for i in range(0, 2 - Line): SetText += "\n"
	
	return SetText

func ItemText() -> String:
	var ItemsDisplay: Array = []
	var LineCount: int = 0
	
	for n in len(Globals.Items):
		ItemsDisplay.append(Globals.Items[LineCount][0])
		LineCount += 1
	
	var List: Array = ItemsDisplay.slice(ItemPage * 4, (ItemPage * 4) + 3)
	var SetText: String = ""
	var Line: int = 0
	
	for Element in range(0, len(List)):
		SetText += "   * " + List[Element]
		for i in range(0, 10 - len(List[Element])): SetText += " "
		SetText += ""
		if (Element + 1) % 2 == 0:
			SetText += "\n"
			Line += 1
	
	for i in range(0, 2 - Line): SetText += "\n"
	SetText += "                    PAGE " + str(ItemPage + 1)
	
	return SetText
