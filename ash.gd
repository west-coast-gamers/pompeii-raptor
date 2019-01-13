extends Node2D
var Util = preload('res://util.gd')
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	#var item = $Sprite/Particles2D.process_material.EMISSION_SHAPE_BOX.x
	var main = get_tree().get_root().get_node('main')
	var material = $ash.process_material
	var box = material.emission_box_extents
	
	var height = main.game_area['height_in_tiles']*main.game_area['tile_size']
	var width = main.game_area['width_in_tiles']*main.game_area['tile_size']
	box.x = width
	box.y = height
	material.set_emission_box_extents(box)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
