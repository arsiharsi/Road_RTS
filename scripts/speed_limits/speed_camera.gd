extends Area2D

export(PackedScene) var detect_point_scene
export(PackedScene) var zone_scene
var detect_point
var cars_array = []
var all_count = 0
var avg_speed = 0.0
export var limit_speed = 120.0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if zone_scene:
		var zone = zone_scene.instance()
		for i in range(0, get_child_count()):
			if get_child(i) is CollisionShape2D:
				zone.color = Color(1,1,1,0.25)
				get_child(i).add_child(zone)
	detect_point = detect_point_scene
	pass # Replace with function body.

func get_avg(array:Array):
	var avg = 0.0
	if array.size() != 0:
		for i in range(0, array.size()):
			avg += sign(array[i].act_speed)*array[i].speed
		avg = avg/array.size()
	return avg
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	avg_speed = get_avg(cars_array)
	pass



func _on_speed_camera_body_entered(body):
	if body.has_method("get_class"):
		if body.get_class() == "car":
			var n_point = detect_point.instance()
			n_point.target = body
			if body.speed > limit_speed + 20:
				n_point.self_modulate = Color.red
				var fine_ammount = 0
				if body.speed - limit_speed > 20:
					fine_ammount = 500
				if body.speed - limit_speed > 40:
					fine_ammount = int(rand_range(1000,1500))
				if body.speed - limit_speed > 60:
					fine_ammount = int(rand_range(2000,2500))
				if body.speed - limit_speed > 80:
					fine_ammount = int(5000)
				Global.fine += fine_ammount
				Global.log_stuff(1, "Нарушение скоростного режима: Автомобиль с номером "+str(body.id_number)
				+ " превысил скорость на "+str(body.speed-limit_speed)+". Объем штрафа: "+str(fine_ammount))
				print("UNLAW: "+str(body.id_number))
			$points.add_child(n_point)
			cars_array.append(body)
	pass # Replace with function body.


func _on_speed_camera_body_exited(body):
	if body.has_method("get_class"):
		if body.get_class() == "car":
			cars_array.erase(body)
			for i in range(0, $points.get_child_count()):
				if $points.get_child(i).target == body:
					$points.get_child(i).queue_free()
					break
	pass # Replace with function body.
