extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const Hero_Speed = 30

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	var direction = Vector2(0, 0)
	if Input.is_action_pressed('hero_right'):
		direction.x += 1
	if Input.is_action_pressed('hero_left'):
		direction.x -= 1
	if Input.is_action_pressed('hero_up'):
		direction.y -= 1
	if Input.is_action_pressed('hero_down'):
		direction.y += 1
	
	$hero.position = $hero.position + direction*delta*Hero_Speed
	pass
