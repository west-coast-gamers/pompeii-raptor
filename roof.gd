extends Node2D

var house_name = 'unknown'

func doAction(body):
	print ("Enter house")
	body.enter_house(house_name)
		
func get_house_name():
	return house_name

func _on_entrancearea_area_entered(area):
	print ("Entered house door (" + house_name + ")")
	var hero = area
	if hero.has_method("isCloseToMe"):
		hero.isCloseToMe(self)

func _on_entrancearea_area_exited(area):
	print ("exit house door (" + house_name + ")")
	var hero = area
	if hero.has_method("isNotCloseToMe"):
		hero.isNotCloseToMe(self)
