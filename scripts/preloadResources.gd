
extends Node

#Scripts
var gameCookies		= preload("gameCookies.gd")
var gameLevel		= preload("gameLevel.gd")
var gameSwap		= preload("gameSwap.gd").Swap
var gameChain		= preload("gameChain.gd").Chain

#Normal
var Croissant		= preload("res://textures/cookies/Croissant.png")
var Cupcake			= preload("res://textures/cookies/Cupcake.png")
var Danish			= preload("res://textures/cookies/Danish.png")
var Donut			= preload("res://textures/cookies/Donut.png")
var Macaroon		= preload("res://textures/cookies/Macaroon.png")
var SugarCookie 	= preload("res://textures/cookies/SugarCookie.png")

#Highlighted
var CroissantH		= preload("res://textures/cookies/Croissant-Highlighted.png")
var CupcakeH		= preload("res://textures/cookies/Cupcake-Highlighted.png")
var DanishH			= preload("res://textures/cookies/Danish-Highlighted.png")
var DonutH			= preload("res://textures/cookies/Donut-Highlighted.png")
var MacaroonH		= preload("res://textures/cookies/Macaroon-Highlighted.png")
var SugarCookieH	= preload("res://textures/cookies/SugarCookie-Highlighted.png")

#other Res
var bubble			= preload("res://FX/bubble.png")
var divine			= preload("res://FX/divine.png")
var starExp			= preload("res://scene/explode_star.tscn")

func _ready():
	pass