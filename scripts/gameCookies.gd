
var isnull = true
var column
var row
var predefined = false
var cookieType = 0
var sprite

func highlightedSpriteName():
	var spriteNamesHigh = ["Null", "Croissant-high", "Cupcake-high", "Danish-high", "Donut-high", "Macaroon-high", "SugarCookie-high"]
	return spriteNamesHigh[cookieType]

func spriteName():
	var spriteNames = ["Null", "Croissant", "Cupcake", "Danish", "Donut", "Macaroon", "SugarCookie"]
	return spriteNames[cookieType]

func _init(type = 0):
	if type: predefined = true
	cookieType = type
