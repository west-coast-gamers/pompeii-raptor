extends Node2D

var Util = preload('res://util.gd')

const Hero_Speed = 240

var hero_velocity = Vector2()

signal hero_enter_house

var heroWorldPoistion = null
var heroWorldDirection = null

var hero_in_house = false

func _ready():
	pass

func _process(delta) :
	var velocity = Vector2(0, 0)
	var direction = 0
	if Input.is_action_pressed('hero_right'):
		velocity.x += 1
		direction += 0
	if Input.is_action_pressed('hero_left'):
		velocity.x -= 1
		direction += 180
	if Input.is_action_pressed('hero_up'):
		velocity.y -= 1
		direction += 90
	if Input.is_action_pressed('hero_down'):
		velocity.y += 1
	if Input.is_action_just_pressed('hero_do'):
		tryDoActionOnItem()

	velocity = velocity.normalized() * Hero_Speed
	hero_velocity = velocity
	
	move_and_collide(hero_velocity * delta)
	
	var speed = sqrt(velocity.x*velocity.x + velocity.y*velocity.y)
	if speed>0:
		$"hero-01".rotation = atan2(hero_velocity.y,hero_velocity.x)
		if $"hero-01/anim".current_animation != "running":
			$"hero-01/anim".play("running")
		

var _item = null
func isCloseToMe(item):
       print ("is close")
       _item = item

func tryDoActionOnItem():
	print ("tries something")
	if _item != null:
		if _item.has_method("_give_gold_to_hero"):
			_item._give_gold_to_hero(self)
		_item.doAction(self)

func isNotCloseToMe(item):
	_item = null
	
	
func exit_house():
	if hero_in_house:
		hero_in_house = false
		position = heroWorldPoistion
		$"hero-01".rotation = heroWorldDirection
		emit_signal('hero_enter_house', "")
	
func enter_house(house_name):
	if not hero_in_house:
		hero_in_house = true
		heroWorldPoistion = position
		heroWorldDirection = $"hero-01".rotation + PI
		emit_signal('hero_enter_house', house_name)
	