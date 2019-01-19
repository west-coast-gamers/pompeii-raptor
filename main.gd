

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
var ash_scene = load('res://ash.tscn')
var roof_01_scene = load('res://roof-01.tscn')
#var roof_02_scene = load('res://roof-02.tscn')
var door_scene = load('res://door.tscn')
var road_scene = load('res://roads.tscn')
var city_wall_scene = load('res://city_wall/city_wall.tscn')
var house_01_scene = load('res://house-01.tscn')
var house_02_scene = load('res://house-02.tscn')
var roof_2_4_scene = load('res://roof-2-4-normal.tscn')
var roof_6_6_villa_scene = load('res://roof-6-6-villa.tscn')

var aska_scene = load('res://aska.tscn')

var house_to_enter

# :Tips - dictionaries works like a struct in some sense since it can be
# access using a . syntax, e.g. game_area.offset.
var game_area = {'height_in_tiles': 40, 'width_in_tiles': 256, 'tile_size': 32.0, 'timeToBlack':60*600, 'ashAlphaDiff':0.1 }

var aska_map=[]
var ashIterationsCount = 0
var currentHouseName = ""

var NoOfAshIterations = calcAshIterations()


var houses_in_da_world = [
	{
		'roof_scene'     : roof_01_scene,      # Which scene to use for creating a roof.
		'roof_position'  : Vector2(320, 640),  # Where to put the roof in the world.
		'roof_rotation'  : 1.5,                #
		'roof_scale'     : 3,                  # The scale to draw the roof at.
		'house_scene'    : house_01_scene,     # Which scene to use when creating a house (internal).
		'house_instance' : null,               # Store house instance here.
		'house_name'     : 'house-01',         # Name of house, store this in roof the get a connection.
	}, 
	{
		'roof_scene'     : roof_01_scene,
		'roof_position'  : Vector2(1300, 100),
		'roof_rotation'  : 0.5, 
		'roof_scale'     : 3,
		'house_scene'    : house_02_scene,
		'house_instance' : null, 
		'house_name'     : 'house-02',
		'house_scale'    : 3
	}, 
	{
		'roof_scene'     : roof_6_6_villa_scene,
		'roof_position'  : Vector2(650, 650),
		'roof_rotation'  : 0, 
		'roof_scale'     : 1,
		'house_scene'    : house_02_scene,
		'house_instance' : null, 
		'house_name'     : 'house-03',
	}, 
	{
		'roof_scene'     : roof_2_4_scene,
		'roof_position'  : Vector2(1330, 650),
		'roof_rotation'  : 0.25, 
		'roof_scale'     : 1,
		'house_scene'    : house_01_scene,
		'house_instance' : null, 
		'house_name'     : 'house-04',
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
		
	var city_wall = city_wall_scene.instance()	
	var x = city_wall.create_city_wall_polygons()
	$world.add_child(city_wall)
	var roads = road_scene.instance()
	$world.add_child(roads)
	roads.add_road_between(x["coordinates"][0], x["angles"][0], x["coordinates"][2], x["angles"][2], 20)
	roads.add_road_between(x["coordinates"][1], x["angles"][1], x["coordinates"][3], x["angles"][3], 20)
	
	#ash has no position
	$world/tiles.add_child(ash_scene.instance())
		
	var house_position = Vector2(0, -1500)
	
	for h in houses_in_da_world:
		var roofPoc = h.roof_scene.instance()
		roofPoc.position = h.roof_position
		roofPoc.rotate(h.roof_rotation)
		roofPoc.apply_scale(Vector2(h.roof_scale, h.roof_scale))
		roofPoc.house_name = h.house_name
		$world/tiles.add_child(roofPoc)
		
		var house_poc = h.house_scene.instance()
		h.house_instance = house_poc
		house_poc.position = house_position
		for node in house_poc.get_node('Inventory').get_children(): 
			node.position += house_position
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

	if Input.is_action_just_pressed ('debug_f1'):
		if currentHouseName =="":
			$'hero'.enter_house("house-01")
		else:
			$'hero'.exit_house()
		
	elif Input.is_action_just_pressed ('debug_f2'):
		if currentHouseName =="":
			$'hero'.enter_house("house-02")
		else:
			$'hero'.exit_house()
		
	ashIterationsCount +=NoOfAshIterations
	while (ashIterationsCount>1):
		ashIterationsCount -=1
		addAsh()



func _on_hero_hero_enter_house(house_name):
	currentHouseName = house_name
	if house_name == "":
		#is exit
		$world/world_ap.play('fade_out')
		$'hero/Camera2D'.useOutDoorCamera()
		$world/world_ap.play('fade_in')
		pass
	else:
		for h in houses_in_da_world:
			if house_name == h.house_name:
				currentHouseName = house_name
				$world/world_ap.play('fade_out')
				house_to_enter = h.house_instance
				$hero.position = house_to_enter.get_entry_position_global()
				house_to_enter.enter_house()
				$'hero/Camera2D'.useRoomCamera($hero.position)
				$world/world_ap.play('fade_in')
				
	
func _on_world_ap_animation_finished(anim_name):
	pass

