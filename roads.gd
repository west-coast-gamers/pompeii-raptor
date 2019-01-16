extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const PAVEMENT_WIDTH = 40
const SMOOTHNESS = 0.1

var road_surface_scene = load('res://road_surface.tscn')
var tower = load('res://tower.tscn')

func add_road_between(p0, a0, p3, a3, width):
	var straight_distance = p0.distance_to(p3)
	var clen = straight_distance * 0.3
	
	var left_side = []
	var right_side = []
	var left_side_pavement = []
	var right_side_pavement = []

	var p1 = p0 + Vector2(cos(a0), sin(a0))*clen
	var p2 = p3 + Vector2(cos(a3), sin(a3))*clen

	var t = 0
	while t <= 1.0:
		var midpoint = pow(1-t, 3)*p0 + 3.0*pow(1-t,2)*t*p1 + 3.0*(1-t)*pow(t,2)*p2 + pow(t,3)*p3
		var derivative = -3.0*pow(1-t,2)*p0 + 3.0 * (-2.0*(1-t)*t + pow(1-t,2))*p1 + 3.0*(-pow(t,2)+2.0*(1-t)*t)*p2 + 3.0*pow(t,2)*p3
		
		var angle = derivative.angle() + PI/2
		var v_left = Vector2(cos(angle), sin(angle))
		var v_right = Vector2(cos(angle + PI), sin(angle + PI))
		
		left_side.append(midpoint + v_left * width)
		right_side.append(midpoint + v_right * width)
		#left_side_pavement.append(midpoint + v_left * (width + PAVEMENT_WIDTH))
		#right_side_pavement.append(midpoint + v_right * (width + PAVEMENT_WIDTH))
		t = t + SMOOTHNESS

	left_side.invert()
	right_side_pavement.invert()
	
	var road = road_surface_scene.instance()
	road.polygon = left_side + right_side
	# TODO: darken road
	# TODO: add pavement
	#pavement = road_surface_scene.instance()
	
	add_child(road)
	
	
static func intersection_point(road1, road2):
	pass
	

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
