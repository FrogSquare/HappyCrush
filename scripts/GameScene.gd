extends Node

export(String, FILE, "*.json") var jsonFile = "res://Level/Level_1.json" setget set_jsonfile

func set_jsonfile(value):
	jsonFile = value
	global.jsonLevelFile = jsonFile

func _enter_tree():
	jsonFile = "res://Level/Level_1.json"

func _ready():
	var winSize = get_parent().get_VisibleSize()
	get_node("GameLayer").addTiles()
	
	beginGame()

func beginGame():
	var level = get_node("GameLayer").get_child(2)
	global.targetScore = level.targetScore
	global.movesLeft = level.maximumMoves
	global.score = 0
	
	level.resetcomboMultiplier()
	get_node("GameLayer").animateBeginEndGame()
	shuffle()
	
func shuffle():
	var levelG = get_node("GameLayer").get_child(2)
	get_node("GameLayer").removeAllCookies()
	
	var newCookies = levelG.shuffle()
	get_node("GameLayer").addSpritesFor(newCookies)
	get_node("GameLayer").setUserInteraction(true);
