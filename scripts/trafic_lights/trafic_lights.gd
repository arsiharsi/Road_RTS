extends Area2D


func get_class():
	return "trafic_lights"

export var is_main = true
export var need_deviation = false
export var deviation = 1.0
export(String, "both","main","slave") var type_way
export(NodePath) var main_zone_car_count
export(NodePath) var slave_zone_car_count
export(NodePath) var trafic_master_node
export(NodePath) var left_zone
export(NodePath) var right_zone
export(int, 7, 120) var duration
export(String, "working", "no_connection", "fail") var state = "working"
export(String, "go", "wait", "stop", "ready") var work_state = "go"
var green_light = false
var yellow_light = false
var red_light = false

var hor_count = 0
var vert_count = 0
var all_count = 0
var avg_speed = 0.0
var consumption = 0.005

var time_left_leg = 7
var reconect_time_left = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func reset_lights():
	if is_main:
		state = "working"
		work_state = "go"
		$timers/real_timer.start(duration)


# Called when the node enters the scene tree for the first time.
func _ready():
	if is_main:
		$timers/real_timer.start(duration)
	if left_zone:
		var l_zone = get_node(left_zone)
		$base_left.global_position = l_zone.global_position
		$base_left.global_rotation = l_zone.global_rotation
	else:
		$base_left.hide()
	if right_zone:
		var r_zone = get_node(right_zone)
		$base_right.global_position = r_zone.global_position
		$base_right.global_rotation = r_zone.global_rotation
	else:
		$base_right.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if is_main:
		reconect_time_left = $timers/reconnect_timer.time_left
		if state == "working":
			var master_cars = get_node_or_null(main_zone_car_count)
			var slave_cars = get_node_or_null(slave_zone_car_count)
			if master_cars:
				master_cars.show()
			if slave_cars:
				slave_cars.show()
			consumption = rand_range(0.04, 0.06)
			time_left_leg = $timers/real_timer.time_left
			if need_deviation:
				car_count_decision()
			if type_way == "main":
				work_state = "go"
			if type_way == "slave":
				work_state = "stop"
			set_lights(work_state)
			if work_state == "go":
				set_zones(false)
			else: 
				set_zones(true)
		else:
			var master_cars = get_node_or_null(main_zone_car_count)
			var slave_cars = get_node_or_null(slave_zone_car_count)
			if master_cars:
				master_cars.hide()
			if slave_cars:
				slave_cars.hide()
			consumption = rand_range(0.1, 0.2)
			time_left_leg = -1
			hor_count = -1
			all_count = -1
			vert_count = -1
			set_zones(true)
	else:
		if trafic_master_node:
			var trafic_master = get_node(trafic_master_node)
			state = trafic_master.state
			if trafic_master.state == "working":
				set_lights_opposing(trafic_master.work_state)
				if trafic_master.work_state == "stop":
					set_zones(false)
				else:
					set_zones(true)
			else:
				set_zones(true)
	pass


func calculate_avg_speed():
	if main_zone_car_count and slave_zone_car_count:
		var master_cars = get_node_or_null(main_zone_car_count)
		var slave_cars = get_node_or_null(slave_zone_car_count)
		if slave_cars.cars_array.size() == 0:
			avg_speed = master_cars.avg_speed
		elif master_cars.cars_array.size() == 0:
			avg_speed = slave_cars.avg_speed
		else:
			avg_speed = (master_cars.avg_speed + slave_cars.avg_speed)/2
	pass

func car_count_decision():
	if main_zone_car_count and slave_zone_car_count:
		var master_cars = get_node_or_null(main_zone_car_count).cars_array.size()
		hor_count = master_cars
		var slave_cars = get_node_or_null(slave_zone_car_count).cars_array.size()
		vert_count = slave_cars
		all_count = hor_count + vert_count
		calculate_avg_speed()
		if master_cars != 0 and slave_cars !=0:
			deviation = float(master_cars)/float(slave_cars)
		else:
			deviation = 1.0
	else:
		print(name+" NOT SET")
	if main_zone_car_count and not slave_zone_car_count:
		var master_cars = get_node_or_null(main_zone_car_count).cars_array.size()
		avg_speed = get_node_or_null(main_zone_car_count).avg_speed
		hor_count = master_cars
		all_count = hor_count

func set_zones(zone_state):
	if left_zone:
		get_node(left_zone).set_deferred("disabled", not zone_state)
	if right_zone:
		get_node(right_zone).set_deferred("disabled", not zone_state)


func set_lights(act_state):
	match act_state:
		"go":
			green_light = true
			yellow_light = false
			red_light = false
		"wait":
			green_light = false
			yellow_light = true
			red_light = false
		"stop":
			green_light = false
			yellow_light = false
			red_light = true
		"ready":
			green_light = false
			yellow_light = true
			red_light = true
	recolor(red_light, yellow_light, green_light)

func set_lights_opposing(act_state):
	match act_state:
		"go":
			green_light = false
			yellow_light = false
			red_light = true
		"wait":
			green_light = false
			yellow_light = true
			red_light = true
		"stop":
			green_light = true
			yellow_light = false
			red_light = false
		"ready":
			green_light = false
			yellow_light = true
			red_light = false
	recolor(red_light, yellow_light, green_light)


func rand_lights():
	green_light = bool(int(rand_range(0,2)))
	yellow_light = bool(int(rand_range(0,2)))
	red_light = bool(int(rand_range(0,2)))
	recolor(red_light, yellow_light, green_light)

func no_connection_lights():
	green_light = false
	yellow_light = not yellow_light
	red_light = false
	recolor(red_light,yellow_light,green_light)


func recolor(red, yellow, green):
	$base_left/green.visible = green
	$base_right/green.visible = green
	$base_left/red.visible = red
	$base_right/red.visible = red
	$base_left/yellow.visible = yellow
	$base_right/yellow.visible = yellow

func _on_switch_timer_timeout():
	if is_main:
		if state == "working":
			if work_state == "wait":
				work_state = "stop"
				$timers/real_timer.start(clamp(duration*(1/deviation),7,120))
				Global.log_stuff(0,"Переключение светофора "+name+". Длительность: "+str(clamp(duration*deviation,7,120)))
			if work_state == "ready":
				work_state = "go"
				$timers/real_timer.start(clamp(duration*deviation,7,120))
				Global.log_stuff(0,"Переключение светофора "+name+". Длительность: "+str(clamp(duration*deviation,7,120)))
	pass # Replace with function body.


func _on_real_timer_timeout():
	if is_main:
		if state == "working":
			if work_state == "go":
				work_state = "wait"
				$timers/switch_timer.start()
			elif work_state == "stop":
				work_state = "ready"
				$timers/switch_timer.start()
	pass # Replace with function body.


func _on_fail_timer_timeout():
	if state == "fail":
		rand_lights()
	pass # Replace with function body.



func _on_no_connection_timeout():
	if state == "no_connection":
		no_connection_lights()
	pass # Replace with function body.


func _on_trafic_lights_body_entered(body):
	if body.has_method("get_class"):
		if body.get_class() == "car":
			body.trafic_lights_stop()
	pass # Replace with function body.


func _on_trafic_lights_body_exited(body):
	if body.has_method("get_class"):
		if body.get_class() == "car":
			body.trafic_lights_go()
	pass # Replace with function body.


func _on_button_pressed():
	if is_main:
		Global.current_trafic_light = self
	else:
		Global.current_trafic_light = get_node(trafic_master_node)
	pass # Replace with function body.


func _on_cost_timer_timeout():
	Global.energy_cost += consumption*10
	pass # Replace with function body.


func lost_connection():
	if is_main:
		state = "no_connection"
		Global.log_stuff(2, name+": потерян сигнал, срочно переподключите этот светофор")
		Global.create_notification(2, name+": потерян сигнал, срочно переподключите этот светофор", global_position)

func broken():
	if is_main:
		state = "fail"
		Global.log_stuff(2, name+": критическая ошибка в работе светофора, срочно отправьте службу по ремонту")
		Global.create_notification(2, name+": критическая ошибка в работе светофора, срочно отправьте службу по ремонту", global_position)


func start_reconnect():
	$timers/reconnect_timer.start(rand_range(5, 10))
	pass

func reconnect():
	if state == "no_connection":
		var broke_chance=rand_range(0,1)
		if broke_chance >0.9:
			broken()
		else:
			state = "working"
			reset_lights()
	pass


func _on_reconnect_timer_timeout():
	reconnect()
	pass # Replace with function body.

func repair():
	if state != "working":
		state = "working"
		reset_lights()
		Global.repair_cost += int(rand_range(5000, 15000))

func start_repair():
	if $timers/repair_timer.time_left == 0:
		$timers/repair_timer.start(rand_range(10, 30))
	pass


func _on_repair_timer_timeout():
	repair()
	pass # Replace with function body.
