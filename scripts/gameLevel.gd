extends Node

const NULL = 0

var gameCookie = preload("gameCookies.gd")
var Swap = preload("gameSwap.gd").Swap
var gameChain = preload("gameChain.gd").Chain

var tileMask = preload("res://textures/grid/MaskTile.png")

var targetScore
var maximumMoves
var definedType = -1

var comboMultiplier
var _tiles = []
var _cookies = []
var possibleSwaps = []

class Tile:
	var type
	
	func _init(t = null):
		if t == null: type = global.TILE_NORMAL
		else: type = t

func createLighMaskAt(pos, layer):
	var light = Light2D.new()
	light.set_enabled(true)
	light.set_texture(tileMask)
	light.set_item_mask(global.TILE_MASK)
	light.set_pos(pos)
	light.set_mode(Light2D.MODE_MASK)
	
	layer.add_child(light)

func tileAt(column, row):
	if _tiles.empty(): return null
	return _tiles[column][row];

func createCookieAt(column, row, cookieType):
	var cookie = gameCookie.new()
	cookie.cookieType = cookieType
	cookie.column = column
	cookie.row = row
	cookie.isnull = false
	
	_cookies[column][row] = cookie
	return cookie

func cookieAt(column, row):
	if column == null || row == null: print("Wrong loc"); return null
	
	assert(column >= 0 && column < global.NumColumns)
	assert(row >= 0 && row < global.NumRows)
	
	return _cookies[column][row]

func initWithFile(file_path):
	_tiles.clear()
	_cookies.clear()
	
	var file = File.new()
	if file.file_exists(file_path):
		file.open(file_path, File.READ)
	else: print("File Not exists"); return
	
	var txt = file.get_as_text()
	
	var dict = Dictionary()
	dict.parse_json(txt)
	
	var tileset = dict["tiles"]
	maximumMoves = dict["moves"]
	targetScore = dict["targetScore"]
	definedType = dict["definedType"]
	
	_tiles.resize(global.NumColumns)
	_tiles.append(Array().resize(global.NumRows))
	
	_cookies.resize(global.NumColumns)
	_cookies.append(Array().resize(global.NumRows))
	
	for column in range(global.NumColumns):
		_tiles[column] = []
		_cookies[column] = []
		for row in range(global.NumRows):
			if tileset[row][column] > 1: _cookies[column].append(gameCookie.new(tileset[row][column]-5))
			else: _cookies[column].append(gameCookie.new())
			
			if tileset[row][column] != 0: _tiles[column].append(Tile.new())
			else: _tiles[column].append(null)

func performSwap(swap):
	var columnA = swap.cookieA.column;
	var rowA = swap.cookieA.row;
	
	var columnB = swap.cookieB.column;
	var rowB = swap.cookieB.row;
	
	if columnA == null || columnB == null || rowA == null || rowB == null: return
	
	_cookies[columnA][rowA] = swap.cookieB;
	swap.cookieB.column = columnA;
	swap.cookieB.row = rowA;
	
	_cookies[columnB][rowB] = swap.cookieA;
	swap.cookieA.column = columnB;
	swap.cookieA.row = rowB;

func isPossible(swap):
	for pSwap in possibleSwaps:
		if pSwap.isEqual(swap): return true
	
	return false

func _init():
	randomize()

func _ready():
	initWithFile(global.jsonLevelFile)

func shuffle():
	var set = []
	possibleSwaps.clear()
	
	while true:
		set = createInitialCookies()
		detectPossibleSwaps()
		if possibleSwaps.size() != 0: break
	
	return set;

func resetcomboMultiplier():
	comboMultiplier = 1

func detectPossibleSwaps():
	var set = []
	
	for row in range(global.NumRows):
		for column in range(global.NumColumns):
			var cookie = _cookies[column][row]
			if cookie != null and not cookie.isnull:
				if column < global.NumColumns - 1:
					var other = _cookies[column+1][row]
					if (other != null and not other.isnull):
						_cookies[column][row] = other
						_cookies[column+1][row] = cookie
						
						if hasChainAt(column+1, row) || hasChainAt(column, row):
							var swap = Swap.new()
							swap.setCookies(cookie, other)
							set.append(swap)
							
						_cookies[column][row] = cookie
						_cookies[column+1][row] = other
						
				if row < global.NumRows - 1:
					var other = _cookies[column][row+1]
					if (other != null and not other.isnull):
						_cookies[column][row] = other
						_cookies[column][row+1] = cookie
						
						if hasChainAt(column, row+1) || hasChainAt(column, row):
							var swap = Swap.new()
							swap.setCookies(cookie, other)
							set.append(swap)
							
						_cookies[column][row] = cookie
						_cookies[column][row+1] = other
	
	possibleSwaps.clear()
	possibleSwaps = set
	return possibleSwaps

func printSwaps(swaps):
	print("Possible Swaps: ", possibleSwaps.size())
	for swap in swaps:
		print("CookieA Column: ", swap.cookieA.column, " Row: ", swap.cookieA.row)
		print("CookieB Column: ", swap.cookieB.column, " Row: ", swap.cookieB.row)
		print("\n")

func calculateScores (chains):
	for chain in chains:
		chain.score = 60 * (chain.getCookies().size() - 2) * comboMultiplier
		comboMultiplier += 1

func hasChainAt(column, row):
	if _cookies[column][row] == null || _cookies[column][row].isnull: return false
	
	var cookieType = _cookies[column][row].cookieType
	
	var i = column - 1
	var horzLength = 1
	
	while (i >= 0 && _cookies[i][row].cookieType == cookieType):
		i -= 1
		horzLength += 1
		
	i = column + 1
	while (i < global.NumColumns && _cookies[i][row].cookieType == cookieType):
		i += 1
		horzLength += 1
	
	if (horzLength >= 3): return true
	
	i = row - 1
	var vertLength = 1
	while (i >= 0 && _cookies[column][i].cookieType == cookieType):
		i -= 1
		vertLength += 1
		
	i = row + 1
	while (i < global.NumRows && _cookies[column][i].cookieType == cookieType):
		i += 1
		vertLength += 1
	
	if (vertLength >= 3): return true
	
	return false

func createInitialCookies():
	var set = []
	
	for row in range(global.NumRows):
		for column in range(global.NumColumns):
			if _tiles[column][row] != null && _cookies[column][row].predefined:
				var cookie = createCookieAt(column, row, _cookies[column][row].cookieType)
				set.append(cookie)
			elif _tiles[column][row] != null:
				var cookieType = getRandNum(global.NumCookieTypes, true)
				
				while cookieType == definedType || (column >= 2 && \
				_cookies[column-1][row].cookieType == cookieType && \
				_cookies[column-2][row].cookieType == cookieType) || (row >= 2 && \
				_cookies[column][row-1].cookieType == cookieType && \
				_cookies[column][row-2].cookieType == cookieType): 
					cookieType = getRandNum(global.NumCookieTypes, true)
					
				var cookie = createCookieAt(column, row, cookieType)
				set.append(cookie);
				
	return set

func detectHorizontalMatches():
	var set = []
	set.clear()
	
	for row in range(global.NumRows):
		var column = 0
		for c in range(global.NumColumns - 2):
			if column >= global.NumColumns - 2: break
			if (_cookies[column][row] != null && not _cookies[column][row].isnull):
				var matchType = _cookies[column][row].cookieType
				
				if (_cookies[column+1][row].cookieType == matchType && \
				_cookies[column+2][row].cookieType == matchType):
					var chain = gameChain.new()
					chain.chainType = chain.ChainTypeHorizontal
						
					while true:
						chain.addCookie(_cookies[column][row])
						column += 1
						if (column<global.NumColumns && _cookies[column][row].cookieType!=matchType): break
						elif column >= global.NumColumns: break
						
					set.append(chain)
					continue
			column += 1
	return set

func detectVerticalMatches():
	var set = []
	
	for column in range(global.NumColumns):
		var row = 0
		for r in range(global.NumRows - 2):
			if row >= global.NumRows - 2: break
			if (_cookies[column][row] != null && not _cookies[column][row].isnull):
				var matchType = _cookies[column][row].cookieType
				
				if (_cookies[column][row+1].cookieType == matchType && \
				_cookies[column][row+2].cookieType == matchType):
					var chain = gameChain.new()
					chain.chainType = chain.ChainTypeVertical
					
					while true:
						chain.addCookie(_cookies[column][row])
						row += 1
						if (row < global.NumColumns && _cookies[column][row].cookieType != matchType): break
						elif row >= global.NumColumns: break
					
					set.append(chain)
					continue
			row += 1
	return set

func detectTLMatches(hChains, vChains):
	var set = []
	
	for hChain in hChains:
		for vChain in vChains:
			var chain = gameChain.new()
			var hCookies = hChain.getCookies()
			var vCookies = vChain.getCookies()
			
			for cookie in vCookies:
				var cookieIndex = vCookies.find(cookie)
				var match = hCookies.find(cookie)
				
				if (match == 0 && (cookieIndex == 0 || cookieIndex == vCookies.size()-1)) || \
				(match == hCookies.size()-1 && (cookieIndex == 0 || cookieIndex == vCookies.size()-1)):
					chain.setCookies(vCookies+hCookies)
					chain.chainType = chain.ChainLShape
					chain.matchColumn = cookie.column
					chain.matchRow = cookie.row
					set.append(chain)
					vChains.erase(vChain)
					hChains.erase(hChain)
				elif (match > 0 && match < hCookies.size()-1 && \
				(cookieIndex == 0 || cookieIndex == vCookies.size()-1)) || \
				(cookieIndex > 0 && cookieIndex < vCookies.size()-1 && \
				(match == 0 || match == hCookies.size()-1)):
					chain.setCookies(vCookies+hCookies)
					chain.chainType = chain.ChainTShape
					chain.matchColumn = cookie.column
					chain.matchRow = cookie.row
					set.append(chain)
					vChains.erase(vChain)
					hChains.erase(hChain)
	return set + joinMatches(hChains, vChains)

func detectAllCookiesType(cookieType):
	var set = []
	
	for column in range(global.NumColumns):
		for row in range(global.NumRows):
			var cookie = _cookies[column][row]
			if cookie != null and not cookie.isnull:
				if cookie.cookieType == cookieType:
					set.append(cookie)
	
	return set

func detectAllIn(column = null, row = null):
	var set = []
	
	if column == null:
		for col in range(global.NumColumns):
			var cookie = cookieAt(col, row)
			if not cookie.isnull:
				set.append(cookie)
	elif row == null:
		for r in range(global.NumRows):
			var cookie = cookieAt(column, r)
			if not cookie.isnull:
				set.append(cookie)
	
	return set

func topUpCookies():
	var columns = []
	var cookieType = 0
	
	for column in range(global.NumColumns):
		var array = []
		for row in range(global.NumRows):
			if row >= 0 && not _cookies[column][row].isnull: break
			if _tiles[column][row] != null:
				var newCookieType = getRandNum(global.NumCookieTypes, true)
				while(newCookieType == cookieType):
					cookieType = getRandNum(global.NumCookieTypes, true)
				
				cookieType = newCookieType
				var cookie = createCookieAt(column, row, cookieType)
				
				if array.empty(): columns.append(array)
				array.append(cookie)
	
	return columns

func fillHoles():
	var columns = []
	
	for column in range(global.NumColumns):
		var array = []
		var row = global.NumRows - 1
		for r in range(global.NumRows):
			if _tiles[column][row] != null && _cookies[column][row].isnull:
				for lookup in range(row-1, -1, -1):
					var cookie = _cookies[column][lookup]
					if cookie != null && not cookie.isnull:
						_cookies[column][lookup] = gameCookie.new()
						_cookies[column][row] = cookie
						cookie.row = row
						
						if array.empty(): columns.append(array)
						array.append(cookie)
						break
			row -= 1
	
	return columns

func removeMatches():
	var horzChains = detectHorizontalMatches()
	var vertChains = detectVerticalMatches()
	
	var chains = detectTLMatches(horzChains, vertChains)
	
	removeCookies(chains)
	calculateScores(chains)
	
	return chains  

func joinMatches(array1, array2):
	var set = array1
	
	for item in array2:
		if not array1.has(item):
			set.append(item)
	
	return set

func removeCookies(chains):
	for chain in chains:
		for cookie in chain.getCookies():
			_cookies[cookie.column][cookie.row] = gameCookie.new()

func getRandNum(end, randRange = false):
	if not randRange:
		return randi() % end
	else:
		return int(rand_range(1, end+1))