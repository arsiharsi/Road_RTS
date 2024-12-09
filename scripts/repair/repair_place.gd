extends TouchScreenButton

export var speed = 30.0
export var target_pos = Vector2.ZERO
export var is_active = false
export(String, "start","checking","home") var mission_state
onready var repair_car = $repair_moving
onready var line_to_pointer = $line_to_pointer
var act_speed = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	line_to_pointer.global_position = Vector2.ZERO
	line_to_pointer.set_point_position(0, global_position)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	repair_car.visible = is_active
	repair_car.monitoring = is_active
	if repair_car.global_position.distance_to(target_pos)<10:
		repair_car.get_node("coll").scale = Vector2(4,4)
	else:
		repair_car.get_node("coll").scale = Vector2(1,1)
	line_to_pointer.visible = Global.current_repair_evac == self
	line_to_pointer.set_point_position(1, Global.camera_node.global_position)
	if is_active:
		act_speed = speed*1000/60/60*delta
		var direction = Vector2.ZERO
		if mission_state == "start":
			if repair_car.global_position.distance_to(target_pos)>10:
				direction = repair_car.global_position.direction_to(target_pos)
			elif $wait_timer.time_left == 0:
				$wait_timer.start()
		elif mission_state == "home":
			direction = repair_car.global_position.direction_to(global_position)
			if repair_car.global_position.distance_to(global_position) < 10:
				is_active = false
				mission_state = "start"
		repair_car.global_position += direction*act_speed
	pass


func _on_repair_place_pressed():
	Global.current_repair_evac = self
	pass # Replace with function body.


func _on_repair_moving_area_entered(area):
	if area.has_method("get_class"):
		if area.get_class() == "trafic_lights":
			if area.is_main:
				area.start_repair()
	pass # Replace with function body.


func _on_wait_timer_timeout():
	mission_state = "home"
	pass # Replace with function body.

func call_service(in_pos):
	if not is_active:
		is_active = true
		target_pos = in_pos
		mission_state = "start"
	pass
