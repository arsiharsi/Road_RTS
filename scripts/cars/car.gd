extends KinematicBody2D
func get_class():
	return "car"
# Declare member variables here. Examples:
# var a = 2
#enum possible_states{DRIVING, TRAFIC, ACCIDENT, TURNING}
export var prioritizing = false
var sprite_rotation = 0.0
export(NodePath) var starting_road_switch
export var speed = 0.0
export var unlaw_chance = 0.05
export var crash_chance = 0.001
export var parking_chance = 0.01
export var car_crash_speed = 30.0
var is_car_crash = false
var can_crash = false
export(String, "driving", "at_trafic_lights", "accident", "turning") var state_of_driving = "driving"
var position_to_go = Vector2.ZERO
var id_number = ""
var parking_lot
var colliding_car
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
#	print(name+" "+str($coll.shape.extents.x))
	id_number = Global.generate_id_number()
#	print(id_number)
	if starting_road_switch:
		position_to_go = get_node(starting_road_switch).global_position
	$spr.modulate = Color(rand_range(0,1),rand_range(0,1),rand_range(0,1))
	pass # Replace with function body.


var act_speed = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$on_crash_coll/coll.set_deferred("disabled",state_of_driving != "accident")
	var direction = global_position.direction_to(position_to_go)
	$spr.rotation = direction.angle()
	$car_check.rotation = direction.angle()
	sprite_rotation = $spr.global_rotation
	act_speed = speed*1000/60/60*delta
	if state_of_driving == "driving":
		if $car_check.is_colliding():
			colliding_car = $car_check.get_collider()
			if can_crash and state_of_driving != "accident":
				car_crash($car_check.get_collider())
			elif $car_check.get_collider().state_of_driving != "accident":
				if colliding_car.colliding_car:
					if colliding_car.colliding_car != self:
						act_speed = 0
	elif state_of_driving == "turning":
		if $car_check.is_colliding():
			if can_crash and state_of_driving != "accident":
				car_crash($car_check.get_collider())
	elif state_of_driving == "accident":
		act_speed = 0
		if not $coll.disabled:
			$coll.set_deferred("disabled", true)
	elif state_of_driving == "at_trafic_lights":
		act_speed = 0
	global_position += act_speed*direction
	pass


func set_new_pos(new_pos):
	position_to_go = new_pos


func set_new_speed(new_speed):
	var unlaw = rand_range(0,1)>(1-unlaw_chance)
	if not unlaw:
		speed = new_speed+rand_range(0,19)
	else:
		speed = new_speed+rand_range(20,90)
		speed = clamp(speed,0, 180)

func trafic_lights_stop():
	if state_of_driving == "driving" or state_of_driving == "turning" :
		var unlaw = rand_range(0,1)>(1-unlaw_chance)
		if not unlaw:
			state_of_driving = "at_trafic_lights"
		else:
			speed += rand_range(20,40)

func trafic_lights_go():
	if state_of_driving == "at_trafic_lights":
		state_of_driving = "driving"


func reset_speed():
	speed =speed + rand_range(20, 50)


func car_crash(another_car):
	state_of_driving = "accident"
	if $timers/report_crash_timer.time_left == 0:
		print("name: "+name+"color "+String($spr.modulate)+" crash")
		$timers/report_crash_timer.start(rand_range(30,120))
	if another_car.has_method("get_class"):
		if another_car.get_class() == "car":
			another_car.call_deferred("crash_vict")

func crash_vict():
	state_of_driving = "accident"

func set_speed_car_crash():
	speed = car_crash_speed*rand_range(0.25,0.5)

func reset_speed_car_crash():
	speed = speed + rand_range(0,30)

func _on_car_check_zone_body_entered(body):
	if body.has_method("get_class"):
		if body.get_class() == "car":
			var unlaw = rand_range(0,1)>(1-crash_chance)
			can_crash = unlaw
	pass # Replace with function body.


func turning_mode():
	if state_of_driving == "driving":
		state_of_driving = "turning"

func reset_turning_mode():
	if state_of_driving == "turning":
		state_of_driving = "driving"


func _on_car_crash_speed_down_body_entered(body):
	if body.has_method("get_class"):
		if body.get_class() == "car":
			body.set_speed_car_crash()
	pass # Replace with function body.


func _on_car_check_zone_body_exited(body):
	if body.has_method("get_class"):
		if body.get_class() == "car":
			can_crash = false
	pass # Replace with function body.


func _on_car_crash_speed_down_body_exited(body):
	speed = car_crash_speed*rand_range(1.25,1.5)
	pass # Replace with function body.


func _on_change_car_check_size_timeout():
	$car_check.cast_to.x = rand_range(2,6)
	$timers/change_car_check_size.start(rand_range(0.5,1))
	pass # Replace with function body.


func in_parking(p_lot):
	var chance = rand_range(0,1)>(1-parking_chance)
	if chance:
		print(name+" parking")
		parking_lot = p_lot
		parking_lot.cars_array.erase(self)
		speed = 0
		modulate = Color(1,1,1,0.25)
		$coll.set_deferred("disabled", true)
		$timers/parking_timer.start(rand_range(60, 120))
	pass


func _on_parking_timer_timeout():
	if parking_lot.cars_array.size() == 0:
		parking_lot = null
		speed = rand_range(60,80)
		modulate = Color(1,1,1,1)
		$coll.set_deferred("disabled", false)
	else:
		$timers/parking_timer.start(2)


func _on_report_crash_timer_timeout():
	Global.log_stuff(1,"Сообщение об аварии от "+id_number)
	Global.create_notification(1, "Сообщение об аварии от "+id_number, global_position)
	pass # Replace with function body.

func repair():
	$coll.set_deferred("disabled", false)
	print(name + " repaired")
	state_of_driving = "driving"
	speed = 60

func start_repair():
	if $timers/report_crash_timer.time_left != 0:
		$timers/report_crash_timer.stop()
	$timers/repair_time.start(rand_range(5,10))


func _on_repair_time_timeout():
	print(name + " start repair")
	repair()
	pass # Replace with function body.
