extends Node2D


export var cars_ammount = 50

var car_scene = load("res://tscnes/cars/car.tscn")
# Declare member variables here. Examples:
# var a = 2ё
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$ui.show()
	cars_ammount = Global.in_cars_ammount
	randomize()
	Global.roads_node = $roads
	Global.trafic_lights_node = $trafic_lights
	Global.speed_cameras_node = $speed_cameras
	Global.speed_limits_node = $speed_limits
	Global.cars_node = $cars
	Global.special_parking_node = $special_parking
	Global.parking_node = $parking
	Global.repairments_node = $repairments
	Global.spawn_points_node = $spawn_points
	Global.misc_node = $misc
	Global.camera_node = $camera/cam
	Global.log_stuff(0,"Стартовое сообщение")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Global.cars_node.get_child_count() < cars_ammount:
		spawn_car()
	pass


func spawn_car():
	var car = car_scene.instance()
	for i in range(0, Global.spawn_points_node.get_child_count()):
		var point = Global.spawn_points_node.get_child(i)
		if point.cars_amount == 0:
			car.global_position = point.global_position
			Global.cars_node.add_child(car)
			return
	pass


func _on_change_values_timeout():
	Global.set_all_stuff()
	pass # Replace with function body.
