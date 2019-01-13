extends Node2D

func _ready():
	pass
	
func enter_house():
	show()
	get_tree().get_root().get_node('main/hero/Camera2D').useRoomCamera(position)
	$animation_player.play('fade_in')
	
func leave_house():
	get_tree().get_root().get_node('main/hero/Camera2D').useOutDoorCamera()
	
func get_entry_position_global():
	print(position)
	print($hero_entry_position.position)
	return position + $hero_entry_position.position