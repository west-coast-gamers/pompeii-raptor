extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var guldpengtexture = preload("res://images/coin-01.png")
var safirtexture = preload("res://images/diamond-jewelry.png")
var rubintexture = preload("res://images/rubin2.png")
var diamanttexture = preload("res://images/diamant.png")
var position_tile = Vector2(0, 0)

var swagtyper = [{"value":2, "texture": guldpengtexture, "name":"Guldpeng"}, \
{"value":5, "texture": safirtexture, "name":"Safir"}, {"value":3, "texture": rubintexture, "name":"Rubin"}, \
{"value":6, "texture": diamanttexture, "name":"diamant"}]
 
#var smycken = {"silverpeng": 1, "guldpeng": 2, "rubin": 3, "smaragd": 4, "safir": 5, "diamant": 6}
var min_typ = null

func _ready():
	min_typ = swagtyper[randi()%4+0]
	var smycke = $"swag-01" 
	smycke.set_texture(min_typ["texture"])
	pass

var is_picked = false

func _on_Area2D_body_entered(body):
	print ("enter")
	var hero = body.get_node("..")
	if hero.has_method("isCloseToMe"):
		hero.isCloseToMe(self)

func doAction(body):
	print ("Pick item")
	if is_picked == false:
		hide()
		

func _give_gold_to_hero(smycke):
	self.get_node('../../../CanvasLayer/GuldmatareLabel')._laggtill(min_typ["value"])


func _on_Area2D_body_exited(body):
	print ("exit")
	var hero = body.get_node("..")
	if hero.has_method("isNotCloseToMe"):
		hero.isNotCloseToMe(self)
