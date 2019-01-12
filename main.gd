

extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"


# :Tips - a scene doesn't look like a class but it is one. There is an
# invisible Class declaration around the .tscn file...

var Util = preload('res://util.gd')
var Map = preload('res://map.gd')

var grass_scene = load('res://grass.tscn')
var wall_scene = load('res://wall.tscn')
var tree_scene = load('res://tree.tscn')
var swag_scene = load('res://swag.tscn')
var decorations_scene = load('res://decorations.tscn')

# :Tips - dictionaries works like a struct in some sense since it can be
# access using a . syntax, e.g. game_area.offset.
var game_area = {'height_in_tiles': 40, 'width_in_tiles': 256, 'tile_size': 32.0 }

func _ready():

	var map = Map.load('res://map/map.txt', game_area)
	if map.loaded_ok:

		# Map loaded ok... Create dots, walls etc and insert them
		# into the scene tree. Stuff inserted into the scene tree
		# is rendered by the engine (and has it's magic functions
		# like _process and _ready called).

		# :Tips - the $ syntax is a shortcut (for get_node(node_name))
		# for accessing a node in the scene tree.

		for i in range(0, $world/tiles.get_child_count()):
    		$world/tiles.get_child(i).queue_free()

		for pos in map.grass_positions:
			var dot = grass_scene.instance()
			dot.position_tile = pos
			dot.position = Vector2(pos.x*game_area.tile_size,
				pos.y*game_area.tile_size)
			$world/tiles.add_child(dot)

		# background grass for the swag.
		for pos in map.swag_positions:
			var dot = grass_scene.instance()
			dot.position_tile = pos
			dot.position = Vector2(pos.x*game_area.tile_size,
				pos.y*game_area.tile_size)
			$world/tiles.add_child(dot)
			
		# background grass for the decorations.
		for pos in map.decoration_positions:
			var dot = grass_scene.instance()
			dot.position_tile = pos
			dot.position = Vector2(pos.x*game_area.tile_size,
				pos.y*game_area.tile_size)
			$world/tiles.add_child(dot)

		for pos in map.wall_positions:
			var dot = wall_scene.instance()
			dot.position_tile = pos
			dot.position = Vector2(pos.x*game_area.tile_size,
				pos.y*game_area.tile_size)
			$world/tiles.add_child(dot)

		for pos in map.tree_positions:
			var dot = tree_scene.instance()
			dot.position_tile = pos
			dot.position = Vector2(pos.x*game_area.tile_size,
				pos.y*game_area.tile_size)
			$world/tiles.add_child(dot)

		for pos in map.swag_positions:
			var dot = swag_scene.instance()
			dot.position_tile = pos
			dot.position = Vector2(pos.x*game_area.tile_size,
				pos.y*game_area.tile_size)
			$world/tiles.add_child(dot)
			
		for pos in map.decoration_positions:
			var dot = decorations_scene.instance()
			dot.position_tile = pos
			dot.position = Vector2(pos.x*game_area.tile_size,
				pos.y*game_area.tile_size)
			$world/tiles.add_child(dot)

	else:
		print('Failed to load map')

func _process(delta):
	# Called every frame. Delta is time since last frame.
	pass



