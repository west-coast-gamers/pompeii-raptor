extends Node2D

func _ready():
	pass
	
func enter_house():
	show()
	$animation_player.play('fade_in')
	
func leave_house():
	pass
	
func get_entry_position_global():
	print(position)
	print($hero_entry_position.position)
	return position + $hero_entry_position.position