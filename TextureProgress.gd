extends TextureProgress



func _on_Timer_timeout():
	if self.value < 900:
		self.value += 1
	else:
		return "Game Over!"

