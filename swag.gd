extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var position_tile = Vector2(0, 0)

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass
	


func _on_Area2D_body_entered(body):
	print ("enter")
	var hero = body.get_node("..")
	if hero.has_method("isCloseToMe"):
		hero.isCloseToMe(self)

func doAction(body):
	print ("It did something")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
