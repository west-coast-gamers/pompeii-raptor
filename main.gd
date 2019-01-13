

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
var city_wall_gate_scene = load('res://city_wall_gate.tscn')

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
		
	create_city_wall_polygons()

func _process(delta):
	if Input.is_action_pressed('debug_f1'):
		$world/world_ap.play('fade_out')

func _on_world_ap_animation_finished(anim_name):
	# @Incomplete - inactivate world?
	$"houses/house-01".enter_house()


const THICKNESS = 25.0
const STANDARD_SEGMENT_LENGTH = 300.0
const ANGLE_VARIATION = PI/7

func add_wall_segment(start_of_segment, end_of_segment, angle):
	var wall_segment = city_wall_scene.instance()	
	var p2d = wall_segment.get_node("Border")
	var diff = Vector2(cos(angle + PI/2)*THICKNESS*0.5, sin(angle + PI/2)*THICKNESS*0.5)
	var vertices = [start_of_segment + diff, end_of_segment + diff, end_of_segment - diff, start_of_segment - diff]
	p2d.polygon = PoolVector2Array(vertices)
	var p2df = wall_segment.get_node("BorderFill")
	p2df.polygon = PoolVector2Array(vertices)
	p2df.texture_rotation = angle + PI/2
	$world.add_child(wall_segment)
				
func create_city_wall_polygons():
	randomize()

	var start_of_wall = Vector2(250,550)
	var start_of_segment = start_of_wall
	var number_of_corners = randi()%6 + 6
	var segments_with_gates = [0, int(number_of_corners/4), int(number_of_corners/2), int(3*number_of_corners/4)]
	var current_angle = PI/2 + rand_range(-0.5*ANGLE_VARIATION, 0.5*ANGLE_VARIATION)
	var start_angle = current_angle

	for i in range(0,number_of_corners):
		var angle_per_segment = (2*PI - (start_angle - current_angle))/(number_of_corners - i)
		
		var length = STANDARD_SEGMENT_LENGTH + rand_range(-0.3*STANDARD_SEGMENT_LENGTH, 0.3*STANDARD_SEGMENT_LENGTH)
		var end_of_segment = start_of_segment + Vector2(cos(current_angle)*length, sin(current_angle)*length)
			
		var next_angle
		if i == number_of_corners - 1:
			end_of_segment = start_of_wall
			current_angle = start_of_segment.angle_to_point(end_of_segment)
			next_angle = 0
		else:
			var t = rand_range(-0.5*ANGLE_VARIATION, 0.5*ANGLE_VARIATION)
			next_angle = current_angle - angle_per_segment - t			
			var tower_angle = current_angle + PI - (PI - (current_angle - next_angle))/2
		
		add_wall_segment(start_of_segment, end_of_segment, current_angle)					
		if segments_with_gates.find(i-1) != -1:				
			var gate = city_wall_gate_scene.instance()
			gate.position = start_of_segment + 0.5*(end_of_segment - start_of_segment)
			gate.rotation = current_angle
			
			$world.add_child(gate)
			

			
		current_angle = next_angle
		start_of_segment = end_of_segment
	
