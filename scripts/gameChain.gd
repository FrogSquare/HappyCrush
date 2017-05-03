
class Chain:
	const ChainTypeNone = 0
	const ChainTypeHorizontal = 1
	const ChainTypeVertical = 2
	const ChainLShape = 3
	const ChainTShape = 4
	
	var isnull = true
	var _cookies = []
	var score = 0
	var matchColumn
	var matchRow
	var chainType = ChainTypeNone
	
	func _init():
		_cookies.clear()
	
	func setCookies(cookies):
		_cookies = cookies
	
	func addCookie(cookie):
		if isnull: isnull = false
		
		_cookies.append(cookie)
	
	func getCookies():
		return _cookies
	
	func removeChain():
		pass
