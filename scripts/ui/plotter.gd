extends Node2D

export var max_points = 60
export var plotter_name = "Name"
export(Color) var color_of_line
export var data_string = ""
var data = []
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func update_line():
	if data.size() < max_points:
		for i in range(0, max_points-data.size()):
			data.append(0)
	if $line.get_point_count() < max_points:
		for i in range(0, max_points-$line.get_point_count()):
			$line.add_point(Vector2(i*80/max_points,45))
	var max_point = data.max()*1.25
	$top.text = str(stepify(max_point,0.1))+" "+data_string
	$middle.text = str(stepify(max_point/2,0.1))+" "+data_string
	for i in range(0, max_points):
		if max_point != 0:
			$line.set_point_position(i,Vector2(i*80/max_points,90-data[i]/max_point*90))
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	update_line()
	$line.default_color = color_of_line
	$name.text = plotter_name
	pass # Replace with function body.

func add_data(new_data):
	data.remove(0)
	data.append(new_data)
	update_line()
# Called every frame. 'delta' is the elapsed time since the previous frame.

var prev_mouse_pos = Vector2()
func _process(_delta):
	if $relocate.is_pressed():
		global_position = get_global_mouse_position()
	if $resize.is_pressed():
		if prev_mouse_pos == Vector2.ZERO:
			prev_mouse_pos = global_position - get_global_mouse_position()
		else:
			scale = (global_position - get_global_mouse_position())/prev_mouse_pos
	pass



