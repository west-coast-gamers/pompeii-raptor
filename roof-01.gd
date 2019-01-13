extends Node2D

var house_name = 'unknown'

func _on_Area2D_body_entered(body):
	print ("Entered house door (roof-01)")
	var hero = body # body.get_node("..")
	print (hero.get_name())
	if hero.has_method("isCloseToMe"):
		hero.isCloseToMe(self)

func doAction(body):
	print ("Enter house")

func _on_Area2D_body_exited(body):
	print ("exit roof-01")
	var hero = body.get_node("..")
	if hero.has_method("isNotCloseToMe"):
		hero.isNotCloseToMe(self)
		
func get_house_name():
	return house_name