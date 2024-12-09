extends TouchScreenButton

export var speed = 30.0
export var target_pos = Vector2.ZERO
export var is_active = false
export(String, "start","checking","home") var mission_state
export(NodePath) var starting_road_switch
var start_road_switch_node
onready var evac_car = $evac_moving
onready var line_to_pointer = $line_to_pointer
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var act_speed = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	start_road_switch_node = get_node_or_null(starting_road_switch)
	$line_to_road_switch.global_position = Vector2.ZERO
	$line_to_pointer.global_position = Vector2.ZERO
	$line_to_pointer.set_point_position(0,global_position)
	$line_to_road_switch.set_point_position(0, global_position)
	if start_road_switch_node:
		$line_to_road_switch.set_point_position(1,start_road_switch_node.global_position)
		$line_to_road_switch.show()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	evac_car.visible = is_active
	evac_car.monitoring = is_active
	line_to_pointer.visible = Global.current_repair_evac == self
	line_to_pointer.set_point_position(1, Global.camera_node.global_position)
	if is_active:
		act_speed = speed*1000/60/60*delta
		var direction = Vector2.ZERO
		if mission_state == "start":
			
			if evac_car.global_position.distance_to(target_pos)>10:
				direction = evac_car.global_position.direction_to(target_pos)
			elif $wait_timer.time_left == 0:
				$wait_timer.start()
		elif mission_state == "home":
			direction = evac_car.global_position.direction_to(global_position)
			if evac_car.global_position.distance_to(global_position) < 10:
				is_active = false
				mission_state = "start"
		evac_car.global_position += direction*act_speed
		evac_car.get_node("spr").flip_h = sign(direction.x) == -1
	pass



func _on_evac_place_pressed():
	Global.current_repair_evac = self
	pass # Replace with function body.


func call_service(in_pos):
	if not is_active:
		is_active = true
		target_pos = in_pos
		mission_state = "start"
	pass


func _on_wait_timer_timeout():
	mission_state = "home"
	pass # Replace with function body.


func _on_evac_moving_body_entered(body):
	if is_active:
		if body.get_parent().has_method("get_class"):
			if body.get_parent().get_class() == "car":
				if body.get_parent().state_of_driving == "accident":
					Global.fine += int(rand_range(1500, 5000)*global_position.distance_to(body.get_parent().global_position)/1000)
					body.get_parent().start_repair()
					body.get_parent().global_position = global_position
					body.get_parent().position_to_go = start_road_switch_node.global_position
	pass # Replace with function body.
