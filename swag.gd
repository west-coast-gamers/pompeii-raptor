extends Node2D


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
 
func _spawn_rates():
	randomize()
	var min_typ = null
	var c = randi()%101+1
	if c <= 50:
		min_typ = swagtyper[5]
	elif c > 50 and c <= 70:
		min_typ = swagtyper[0]
	elif c > 70 and c <= 80:
		min_typ = swagtyper[2]
	elif c > 80 and c <= 95:
		min_typ = swagtyper[4]
	elif c > 95 and c <= 98:
		min_typ = swagtyper[1]
	elif c > 98 and c <= 100:
		min_typ = swagtyper[3]
	return min_typ

var a = _spawn_rates()

func _ready():
	var smycke = $"swag-01" 
	smycke.set_texture(a["texture"])

func _on_Area2D_body_entered(body):
	var label = self.get_node('../../../CanvasLayer/GuldmatareLabel')
	if label != null :
		label._laggtill(a["value"])
		var parent = self.get_node("..")
		parent.remove_child(self)
	




