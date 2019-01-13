extends Label

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var balance = 0
var smycken = {"silverpeng": 1, "guldpeng": 2, "rubin": 3, "smaragd": 4, "safir": 5, "diamant": 6}

func _laggtill(varde):
	balance += varde
	self.set_text("Guld: " +  str(balance))

