extends Node2D

const Hero_Speed = 240

var hero_velocity = Vector2()

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func process_input() :
	var velocity = Vector2(0, 0)
	if Input.is_action_pressed('hero_right'):
		velocity.x += 1
	if Input.is_action_pressed('hero_left'):
		velocity.x -= 1
	if Input.is_action_pressed('hero_up'):
		velocity.y -= 1
	if Input.is_action_pressed('hero_down'):
		velocity.y += 1
	
	velocity = velocity.normalized() * Hero_Speed
	hero_velocity = velocity
	

func _physics_process(delta) :
	process_input()
	$"KinematicBody2D".move_and_collide(hero_velocity * delta)
	#$"hero-01/KinematicBody2D".move_and_collide(hero_velocity * delta)