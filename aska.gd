extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var alpha = 0
var alphaDiff
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	#alpha speed
	#10 objekt per ruta
	#x second
	#x * 60 /sizex/sizy *yalpha = 10 
	#main.game_area['timeToBlack']*60/main.game_area['height_in_tiles']/main.game_area['width_in_tiles']*y=10
	
	$Sprite.modulate = Color(128,128,128,0)
	
	position.x += rand_range(-32/2,32/2)
	position.y += rand_range(-32/2,32/2)
	$Sprite.rotation_degrees = rand_range(0,360.0)
	$Sprite.scale = Vector2(rand_range(1/2,2), rand_range(1/2,2))
	alphaDiff = get_tree().get_root().get_node('main').game_area['ashAlphaDiff']

	pass

func doAction():
	alpha = min(alpha + alphaDiff,1)
	
	$Sprite.modulate = Color(0,0,0,alpha)
	
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
