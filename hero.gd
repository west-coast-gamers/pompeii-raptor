extends Node2D

const Hero_Speed = 240

var hero_velocity = Vector2()

func _ready():
	pass

func _process(delta) :
	var velocity = Vector2(0, 0)
	if Input.is_action_pressed('hero_right'):
		velocity.x += 1
	if Input.is_action_pressed('hero_left'):
		velocity.x -= 1
	if Input.is_action_pressed('hero_up'):
		velocity.y -= 1
	if Input.is_action_pressed('hero_down'):
		velocity.y += 1
	if Input.is_action_just_pressed('hero_do'):
		tryDoActionOnItem()

	velocity = velocity.normalized() * Hero_Speed
	hero_velocity = velocity

	$"KinematicBody2D".move_and_collide(hero_velocity * delta)

var _item = null
func isCloseToMe(item):
       print ("is close")
       _item = item

func tryDoActionOnItem():
       print ("tries something")
       if _item != null:
               if _item.has_method("doAction"):
                       _item.doAction(self)
