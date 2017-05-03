
class Swap:
	var cookieA
	var cookieB
	
	func setCookies(a, b):
		cookieA = a
		cookieB = b
	
	func isEqual(object):
		if typeof(object) != typeof(self):
			return false
		
		if object.cookieA.isnull || object.cookieB.isnull: return false
		
		return (object.cookieA == cookieA && object.cookieB == cookieB) || \
		(object.cookieB == cookieA && object.cookieA == cookieB)

	func _init():
		pass
