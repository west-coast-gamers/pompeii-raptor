

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
var city_wall_scene = load('res://city_wall.tscn')
var ash_scene = load('res://ash.tscn')

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
			#dot.position_tile = pos
			dot.position = Vector2(pos.x*game_area.tile_size,
				pos.y*game_area.tile_size)
			$world/tiles.add_child(dot)
	
	else:
		print('Failed to load map')
		
	#ash has no position
	$world/tiles.add_child(ash_scene.instance())

func _process(delta):
	if Input.is_action_pressed('debug_f1'):
		$world/world_ap.play('fade_out')

func _on_world_ap_animation_finished(anim_name):
	# @Incomplete - inactivate world?
	$"houses/house-01".enter_house()

func get_city_wall_polygons():
	randomize()
	
	var wall_segment = city_wall_scene.instance()
	
	var p0 = Vector2(1000,1000)
	var vertices = [p0]
	var p1 = p0
	
	var number_of_corners = rand_range(1,6) + 6
	var angle_per_segment = 2.0*PI / number_of_corners
	var standard_segment_length = 100.0
	var angle_variation = PI/5
	var current_angle = PI/2 + rand_range(0, angle_variation) - 0.5*angle_variation

	print(p0)
	for i in range(1,number_of_corners):
		var length = standard_segment_length + rand_range(1,int(standard_segment_length))
		var p2 = p1 + Vector2(cos(current_angle)*length, sin(current_angle)*length)
		if p0.distance_to(p2) > standard_segment_length:
			vertices.append(p2)
			var t = rand_range(0, angle_variation) - 0.5*angle_variation
		
		
			current_angle -= angle_per_segment + t;
			print(p2.x, ",",p2.y)
			p1 = p2
	
	vertices.append(p0)
	print(p0)
	
	# Marina port is on the first segment
	# North gate, east gate, south gate
	
	# Determine segments for the four gates.
	#
	# If there is a gate on this segment, we add two polygons.
	# 