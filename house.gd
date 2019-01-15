extends Node2D

func _ready():
	pass
	
func enter_house():
	pass
	

func get_entry_position_global():
	print(position)
	print($hero_entry_position.position)
	return position + $hero_entry_position.position
	


func _on_Area2D_body_entered(body):
	body.exit_house()
