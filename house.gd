extends Node2D

func _ready():
	pass
	
func enter_house():
	print('house')
	show()
	$animation_player.play('fade_in')
	
func leave_house():
	pass
