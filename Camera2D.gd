extends Camera2D

func _ready():
	useOutDoorCamera()
	
func useOutDoorCamera():
	var main = get_tree().get_root().get_node('main')
	limit_left = 0
	limit_top = 0
	limit_bottom = main.game_area['height_in_tiles']*main.game_area['tile_size']
	limit_right = main.game_area['width_in_tiles']*main.game_area['tile_size']
	
func useRoomCamera(position):
	#In a room just set at fixed size
	var main = get_tree().get_root().get_node('main')
	var sizeScreen =  main.game_area['tile_size']*100
	limit_left = position.x - sizeScreen/2
	limit_top = position.y - sizeScreen/2
	limit_right = position.x + sizeScreen/2
	limit_bottom = position.y + sizeScreen/2
	
	
#func _process(delta):
#      # Called every frame. Delta is time since last frame.
#      # Update game logic here.
#      pass
