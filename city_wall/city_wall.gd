extends Node

var city_wall_segment_scene = load('res://city_wall/city_wall_segment.tscn')
var city_wall_gate_scene = load('res://city_wall/city_wall_gate.tscn')
var tower_scene = load('res://city_wall/tower.tscn')

const THICKNESS = 32.0 # TODO: use width of resource
const STANDARD_SEGMENT_LENGTH = 300.0
const ANGLE_VARIATION = PI/7

func add_wall_segment(start_of_segment, end_of_segment, angle):
	var wall_segment = city_wall_segment_scene.instance()	
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
	
	add_child(wall_segment)
				
func create_city_wall_polygons():
	randomize()

	var start_of_wall = Vector2(450,550)
	var start_of_segment = start_of_wall
	var number_of_corners = randi()%6 + 6
	var segments_with_gates = [0, int(number_of_corners/4), int(number_of_corners/2), int(3*number_of_corners/4)]
	var current_angle = PI/2 + rand_range(-0.5*ANGLE_VARIATION, 0.5*ANGLE_VARIATION)
	var start_angle = current_angle
	
	var gate_coordinates = []
	var gate_angles = []

	for i in range(0,number_of_corners):
		var angle_per_segment = (2*PI - (start_angle - current_angle))/(number_of_corners - i)
		
		var length = STANDARD_SEGMENT_LENGTH + rand_range(-0.3*STANDARD_SEGMENT_LENGTH, 0.3*STANDARD_SEGMENT_LENGTH)
		var end_of_segment = start_of_segment + Vector2(cos(current_angle)*length, sin(current_angle)*length)
			
		var next_angle
		if i == number_of_corners - 1:
			end_of_segment = start_of_wall
			current_angle = end_of_segment.angle_to_point(start_of_segment)
			next_angle = start_angle + PI
		else:
			var angle_v = rand_range(-0.5*ANGLE_VARIATION, 0.5*ANGLE_VARIATION)
			next_angle = current_angle - angle_per_segment - angle_v
			
		var tower_angle = (next_angle + current_angle)/2

		var tower = tower_scene.instance()
		tower.position = end_of_segment
		tower.rotation = tower_angle
		add_child(tower)
		
		if segments_with_gates.find(i-1) != -1:
			var gate = city_wall_gate_scene.instance()
			gate.position = start_of_segment + 0.5*(end_of_segment - start_of_segment)
			gate.rotation = current_angle + PI/2
			var sz = gate.get_node("Sprite").texture.get_size()
			var h = sz.y / 2 
			
			gate_coordinates.append(gate.position)
			gate_angles.append(current_angle - PI/2)
			
			var gate_start = gate.position + Vector2(cos(current_angle + PI)*h, sin(current_angle + PI)*h)
			var gate_end = gate.position + Vector2(cos(current_angle)*h, sin(current_angle)*h)
			add_wall_segment(start_of_segment, gate_start, current_angle)
			add_wall_segment(gate_end, end_of_segment, current_angle)
			
			add_child(gate)
		else:
			add_wall_segment(start_of_segment, end_of_segment, current_angle)

			
			

			
		current_angle = next_angle
		start_of_segment = end_of_segment
		
	return {"coordinates": gate_coordinates, "angles":gate_angles}

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
