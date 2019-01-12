extends Camera2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	var main = get_tree().get_root().get_node('main')
	limit_left = 0
	limit_top = 0
	limit_bottom = main.game_area['height_in_tiles']*main.game_area['tile_size']
	limit_right = main.game_area['width_in_tiles']*main.game_area['tile_size']

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
