extends Node

export(Texture) var background setget set_background

func set_background(value):
	background = value

func get_VisibleSize():
	return get_parent().get_rect().size

func get_center():
	var vSize = get_VisibleSize()
	return Vector2(vSize.width/2, vSize.height/2)

func _enter_tree():
	OS.set_window_maximized(true);
	pass

func _ready():
	get_node("GameScene/Shuffle").connect("pressed", self, "_shuffle");
	pass

func _shuffle():
	get_node("GameScene").shuffle();
	pass