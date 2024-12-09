extends Area2D

export(PackedScene) var detect_point_scene
var cars_array = []
var avg_speed = 0.0
var detect_point
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	detect_point = detect_point_scene
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	avg_speed = get_avg(cars_array)
	pass


func get_avg(array:Array):
	var avg = 0.0
	if array.size() != 0:
		for i in range(0, array.size()):
			avg += sign(array[i].act_speed)*array[i].speed
		avg = avg/array.size()
	return avg


func _on_car_checkin_zone_body_entered(body):
	if body.has_method("get_class"):
		if body.get_class() == "car":
			var n_point = detect_point.instance()
			n_point.target = body
			$points.add_child(n_point)
			cars_array.append(body)
	pass # Replace with function body.


func _on_car_checkin_zone_body_exited(body):
	if body.has_method("get_class"):
		if body.get_class() == "car":
			cars_array.erase(body)
			for i in range(0, $points.get_child_count()):
				if $points.get_child(i).target == body:
					$points.get_child(i).queue_free()
					break
	pass # Replace with function body.
