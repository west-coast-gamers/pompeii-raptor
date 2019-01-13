

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
var ash_scene = load('res://ash.tscn')
var roof_01_scene = load('res://roof-01.tscn')
var door_scene = load('res://door.tscn')
var tower_scene = load('res://tower.tscn')

var house_01_scene = load('res://house-01.tscn')
var house_02_scene = load('res://house-02.tscn')

var aska_scene = load('res://aska.tscn')

var house_to_enter

# :Tips - dictionaries works like a struct in some sense since it can be
# access using a . syntax, e.g. game_area.offset.
var game_area = {'height_in_tiles': 40, 'width_in_tiles': 256, 'tile_size': 32.0, 'timeToBlack':60*600, 'ashAlphaDiff':0.1 }

var aska_map=[]
var ashIterationsCount = 0


var NoOfAshIterations = calcAshIterations()


var houses_in_da_world = [
	{
		'roof_scene'     : roof_01_scene,      # Which scene to use for creating a roof.
		'roof_position'  : Vector2(320, 640),  # Where to put the roof in the world.
		'roof_rotation'  : 1.5,                #
		'house_scene'    : house_01_scene,     # Which scene to use when creating a house (internal).
		'house_instance' : null,               # Store house instance here.
		'house_name'     : 'house-01'          # Name of house, store this in roof the get a connection.
	}, 
	{
		'roof_scene'     : roof_01_scene,
		'roof_position'  : Vector2(1300, 100),
		'roof_rotation'  : 0.5, 
		'house_scene'    : house_02_scene,
		'house_instance' : null, 
		'house_name'     : 'house-02'
	}, 
]


func calcAshIterations():
	#Constant calculation how many iterations needed (each loop) to get the map fully covered in 'timeToBlack' seconds
	
	var NumberOfObjectsForFullCover =10.0 #about 10 times are needed for full cover
	var NumberOfNodes = game_area['height_in_tiles']*game_area['width_in_tiles']
	var NoOfTimesOnDo = game_area['timeToBlack']*60.0
	var iterations = NumberOfObjectsForFullCover*NumberOfNodes/NoOfTimesOnDo/game_area['ashAlphaDiff']
	return iterations

func _ready():

	calcAshIterations()
	for x in range(game_area['width_in_tiles']+1):
	    aska_map.append([])
	    for y in range(game_area['height_in_tiles']+1):
	        aska_map[x].append(null)

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
			
		for pos in map.door_positions:
			var dot = door_scene.instance()
			dot.position_tile = pos
			dot.position = Vector2(pos.x*game_area.tile_size,
				pos.y*game_area.tile_size)
			$world/tiles.add_child(dot)
	
	else:
		print('Failed to load map')
		
	create_city_wall_polygons()
	#ash has no position
	$world/tiles.add_child(ash_scene.instance())
		
	var house_position = Vector2(0, -1500)
	
	for h in houses_in_da_world:
		var roofPoc = h.roof_scene.instance()
		roofPoc.position = h.roof_position
		roofPoc.rotate(h.roof_rotation)
		roofPoc.apply_scale(Vector2(3, 3))
		roofPoc.house_name = h.house_name
		$world/tiles.add_child(roofPoc)
		
		var house_poc = h.house_scene.instance()
		h.house_instance = house_poc
		house_poc.position = house_position
		house_position += Vector2(1200, 0)
		$houses.add_child(house_poc)

func addAsh():
	var px = randi()%aska_map.size()
	var py = randi()%aska_map[0].size()
	if aska_map[px][py] == null or aska_map[px][py].alpha >=0.5:
		var dot = aska_scene.instance()
		dot.position = Vector2(px*game_area.tile_size,py*game_area.tile_size)
		$world/tiles.add_child(dot)
		aska_map[px][py] = dot
	
	aska_map[px][py].doAction()
	
func _process(delta):

	if Input.is_action_pressed('debug_f1'):
		$world/world_ap.play('fade_out')
		house_to_enter = $"houses/house-01"
	elif Input.is_action_pressed('debug_f2'):
		$world/world_ap.play('fade_out')
		house_to_enter = $"houses/house-02"

	ashIterationsCount +=NoOfAshIterations
	while (ashIterationsCount>1):
		ashIterationsCount -=1
		addAsh()




const THICKNESS = 32.0 # TODO: use width of resource
const STANDARD_SEGMENT_LENGTH = 300.0
const ANGLE_VARIATION = PI/7

func add_wall_segment(start_of_segment, end_of_segment, angle):
	var wall_segment = city_wall_scene.instance()	
	var p2d = wall_segment.get_node("Border")
	var diff = Vector2(cos(angle + PI/2)*THICKNESS*0.5, sin(angle + PI/2)*THICKNESS*0.5)
	var center = start_of_segment + (end_of_segment - start_of_segment)/2
	var vertices = [start_of_segment + diff - center, end_of_segment + diff - center, end_of_segment - diff - center, start_of_segment - diff - center]
	wall_segment.position = center
	p2d.polygon = PoolVector2Array(vertices)
	var p2df = wall_segment.get_node("BorderFill")
	p2df.polygon = PoolVector2Array(vertices)
	p2df.texture_rotation = PI/2 - angle
	p2df.texture_offset = Vector2(THICKNESS/2, 0)		
	
	$world.add_child(wall_segment)
				
func create_city_wall_polygons():
	randomize()

	var start_of_wall = Vector2(450,550)
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
			next_angle = start_angle + PI
		else:
			var t = rand_range(-0.5*ANGLE_VARIATION, 0.5*ANGLE_VARIATION)
			next_angle = current_angle - angle_per_segment - t
			
		var tower_angle = (next_angle + current_angle)/2

		var tower = tower_scene.instance()
		tower.position = end_of_segment
		tower.rotation = tower_angle
		$world.add_child(tower)
		
		if segments_with_gates.find(i-1) != -1:
			var gate = city_wall_gate_scene.instance()
			gate.position = start_of_segment + 0.5*(end_of_segment - start_of_segment)
			gate.rotation = current_angle + PI/2
			var sz = gate.get_node("Sprite").texture.get_size()
			var h = sz.y / 2 
			
			var gate_start = gate.position + Vector2(cos(current_angle + PI)*h, sin(current_angle + PI)*h)
			var gate_end = gate.position + Vector2(cos(current_angle)*h, sin(current_angle)*h)
			add_wall_segment(start_of_segment, gate_start, current_angle)
			add_wall_segment(gate_end, end_of_segment, current_angle)
			
			$world.add_child(gate)
		else:
			add_wall_segment(start_of_segment, end_of_segment, current_angle)

			
			

			
		current_angle = next_angle
		start_of_segment = end_of_segment
	

func _on_hero_hero_enter_house(house_name):
	for h in houses_in_da_world:
		if house_name == h.house_name:
			$world/world_ap.play('fade_out')
			house_to_enter = h.house_instance

func _on_world_ap_animation_finished(anim_name):
	# @Incomplete - inactivate world?
	house_to_enter.enter_house()
	$hero.position = house_to_enter.get_entry_position_global()


