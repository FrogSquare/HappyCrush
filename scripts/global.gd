extends Node

var NumColumns = 8
var NumRows = 9
var NumCookieTypes = 6

var score			= 0
var targetScore		= 0
var movesLeft		= 0
var maxMoves		= 0

const TILE_MASK		= 8
const TILE_WIDTH	= 64.0
const TILE_HEIGHT	= 72.0

const TILE_NORMAL	= 1
const TILE_EMPTY	= 2
const TILE_JELLY	= 3
const TILE_FROZEN	= 4
const TILE_LOCKED	= 5

#The currently active scene
var currentScene = null
var jsonLevelFile = null

func setNumColumns(value):
	NumColumns = value

func setNumRows(value):
	NumRows = value

func get_VisibleSize():
	return get_viewport().get_rect().size

func _ready():
	currentScene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() -1)
	Globals.set("MAX_POWER_LEVEL", 9000)

func setScene(scene):
	currentScene.queue_free()
	var s = ResourceLoader.load(scene)
	currentScene = s.instance()
	get_tree().get_root().add_child(currentScene)
