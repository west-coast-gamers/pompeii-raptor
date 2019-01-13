extends Node

var Util = preload('res://util.gd')

#map parsing 
#W is a wall
# . (dot) is open space - grass maybe


func load(filename, game_area):
	var file = File.new()
	file.open(filename, File.READ)

	var loaded_map = {}
	loaded_map['loaded_ok'] = false
	loaded_map['grass_positions'] = []
	loaded_map['wall_positions'] = []
	loaded_map['tree_positions'] = []
	loaded_map['swag_positions'] = []
	loaded_map['decoration_positions'] = []
	loaded_map['door_positions'] = []

	for y in range(game_area.height_in_tiles):
		if file.eof_reached():
			return loaded_map

		var line = file.get_line()
		var x = 0
		for c in line:

			if c == '.':
				loaded_map.grass_positions.append(Vector2(x, y))
			elif c == 'W':
				loaded_map.wall_positions.append(Vector2(x, y))
			elif c == 'D':
				loaded_map.door_positions.append(Vector2(x, y))
			elif c == 'T':
				loaded_map.tree_positions.append(Vector2(x, y))
			elif c == 'S':
				loaded_map.swag_positions.append(Vector2(x, y))
			elif c == 'R':
				loaded_map.decoration_positions.append(Vector2(x, y))
			else:
				oprint ("wrong tile type")

			x += 1
			if x == game_area.width_in_tiles:
				break

	loaded_map.loaded_ok = true

	return loaded_map
