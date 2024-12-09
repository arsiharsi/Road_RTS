extends Node

var roads_node
var trafic_lights_node:Object
var speed_cameras_node
var speed_limits_node
var cars_node
var special_parking_node
var parking_node
var repairments_node
var misc_node
var camera_node
var spawn_points_node
var ui_node
var camera_zoom = 1
var id_numbers = ""

var current_trafic_light
var current_repair_evac

var in_cars_ammount = 250
var cars_ammount = 0
var avg_speed = 0
var avg_energy_consumption = 0
var energy_cost = 0
var fine = 0
var repair_cost = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta):
#	set_all_stuff()
#	pass


var alphabet = "АВЕКМНОРСТУХ"

func generate_id_number():
	var new_number = ""
	new_number += alphabet[int(rand_range(0,alphabet.length()))]
	new_number += str(int(rand_range(0,10)))
	new_number += str(int(rand_range(0,10)))
	new_number += str(int(rand_range(0,10)))
	new_number += alphabet[int(rand_range(0,alphabet.length()))]
	new_number += alphabet[int(rand_range(0,alphabet.length()))]
	while new_number in id_numbers:
		new_number = ""
		new_number += alphabet[int(rand_range(0,alphabet.length()))]
		new_number += str(int(rand_range(0,10)))
		new_number += str(int(rand_range(0,10)))
		new_number += str(int(rand_range(0,10)))
		new_number += alphabet[int(rand_range(0,alphabet.length()))]
		new_number += alphabet[int(rand_range(0,alphabet.length()))]
	return new_number
	pass


func set_all_stuff():
	# TRAFIC_LIGHTS
	var trafic_l_count = 0
	var trafic_car_count = 0
	var trafic_speed_all = 0
	var trafic_cons_all = 0
	if trafic_lights_node.get_child_count() != 0:
		for i in range(0, trafic_lights_node.get_child_count()):
			var trafic_light = trafic_lights_node.get_child(i)
			if trafic_light.is_main:
				trafic_l_count += 1
				trafic_car_count += trafic_light.all_count
				trafic_speed_all += trafic_light.avg_speed
				trafic_cons_all += trafic_light.consumption
		if trafic_l_count != 0:
			avg_speed = trafic_speed_all/trafic_l_count
			avg_energy_consumption = trafic_cons_all
		cars_ammount = trafic_car_count
	# SPEED_CAMERAS
	var camera_count = 0
	var camera_car_count = 0
	var camera_speed_all = 0
	if speed_cameras_node:
		for i in range(0, speed_cameras_node.get_child_count()):
			var camera = speed_cameras_node.get_child(i)
			camera_speed_all += camera.avg_speed
			camera_count += camera.all_count
			camera_count += 1
			camera_car_count += camera.cars_array.size()
		if camera_count != 0 and camera_speed_all != 0:
			avg_speed = (avg_speed+camera_speed_all/camera_count)/2
			cars_ammount += camera_car_count
	pass

func log_stuff(importance, text):
	if ui_node:
		ui_node.log_on_txt_box(importance, text)

func create_notification(importance, text, target_position):
	if ui_node:
		ui_node.create_notification(importance, text, target_position)
	pass # Replace with functio


