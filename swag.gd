extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var guldpengtexture = preload("res://images/coin-01.png")
var safirtexture = preload("res://images/diamond-jewelry.png")
var rubintexture = preload("res://images/rubin2.png")
var diamanttexture = preload("res://images/diamant.png")
var smaragdtexture = preload("res://images/Jade-jewel.png")
var silverpengtexture = preload("res://images/silvercoin-01.png")
var position_tile = Vector2(0, 0)

var swagtyper = [{"value":2, "texture": guldpengtexture, "name":"Guldpeng"}, \
{"value":5, "texture": safirtexture, "name":"Safir"}, {"value":3, "texture": rubintexture, "name":"Rubin"}, \
{"value":6, "texture": diamanttexture, "name":"diamant"}, \
{"value":4, "texture": smaragdtexture, "name":"smaragd"}, \
{"value":1, "texture": silverpengtexture, "name":"silverpeng"}]
 
#var smycken = {"silverpeng": 1, "guldpeng": 2, "rubin": 3, "smaragd": 4, "safir": 5, "diamant": 6}
var min_typ = null

func _ready():
	randomize()
	min_typ = swagtyper[randi()%7+0]
	var smycke = $"swag-01" 
	smycke.set_texture(min_typ["texture"])

var is_picked = false

func _on_Area2D_body_entered(body):
	self.get_node('../../../CanvasLayer/GuldmatareLabel')._laggtill(min_typ["value"])
	var parent = self.get_node("..")
	parent.remove_child(self)
	




