extends CanvasLayer

onready var clock = $left/up/time/time_lbl
var notification_scene = load("res://tscnes/UI/notification.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func set_values():
	$left/up/values/avg_speed/val.text = str(int(Global.avg_speed))+" км/ч"
	$left/up/values/cars_amount/val.text = str(Global.cars_ammount)+" шт."
	$left/up/values/avg_energy_conusmption/val.text = str(stepify(Global.avg_energy_consumption,0.001))+" kW/с"
	$left/up/hidden_values/energy_cost/val.text = str(stepify(Global.energy_cost,0.01)) + " руб."
	$left/up/hidden_values/fine/val.text = str(Global.fine) + " руб."
	$left/up/hidden_values/repair_cost/val.text = str(Global.repair_cost) + " руб."
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.ui_node = self
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_values()
	$right/top/trafic_light_ui.position.x = -248*int(Global.current_trafic_light!=null)+40
	$right/top/trafic_light_ui/close.visible = Global.current_trafic_light!=null
	if Global.camera_node:
		if Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
			Global.camera_node.global_position.x += 10*Global.camera_zoom*(int(Input.is_action_pressed("ui_right"))-int(Input.is_action_pressed("ui_left")))
			Global.camera_node.global_position.y += 10*Global.camera_zoom*(int(Input.is_action_pressed("ui_down"))-int(Input.is_action_pressed("ui_up")))
#		print(get_viewport().size)
		$left/center/pix_measure/distance.text = str(50*Global.camera_zoom)+" m"
		Global.camera_zoom += 0.1*(-int(Input.is_action_just_pressed("ZOOM_IN")) + int(Input.is_action_just_pressed("ZOOM_OUT")))
		Global.camera_zoom = clamp(Global.camera_zoom, 0.1, 10)
		Global.camera_node.zoom = Vector2(Global.camera_zoom, Global.camera_zoom)
	clock.text = Time.get_time_string_from_system()
	pass



func _on_visible_cars_toggled(button_pressed):
	if Global.cars_node:
		Global.cars_node.visible = button_pressed
	pass # Replace with function body.


func _on_visible_speed_limits_toggled(button_pressed):
	if Global.speed_limits_node:
		Global.speed_limits_node.visible = button_pressed
	pass # Replace with function body.


func _on_change_values_pressed():
	if $left/up/hidden_values.position.x != 0:
		$left/up/values.position.x = $left/up/hidden_values.position.x
		$left/up/hidden_values.position.x = 0
	else:
		$left/up/hidden_values.position.x = $left/up/values.position.x
		$left/up/values.position.x = 0
	pass # Replace with function body.


func _on_close_pressed():
	Global.current_trafic_light = null
	pass # Replace with function body.


var logging_enabled = true
func log_on_txt_box(importance, text):
	var imp = ["Стандартное", "Обратить внимание", "Ошибка!"][importance]
	if logging_enabled:
		$center/bottom/logging.text = "["+Time.get_time_string_from_system()+"]"+imp+": "+text+"\n"+$center/bottom/logging.text
	pass

func create_notification(importance, text, target_position):
	var not_s = notification_scene.instance()
	not_s.importance = importance
	not_s.text = text
	not_s.target_position = target_position
	$center/top/notifications.add_child(not_s)
	pass


func _on_loggin_hide_show_button_pressed():
	if $center/bottom/logging.visible:
		$center/bottom/logging.visible = false
		$center/bottom/logging.rect_position = Vector2(-125, 6)
		$center/bottom/loggin_hide_show_button/lbl.text = "О"
		$center/bottom/loggin_hide_show_button.position = Vector2(145,-22)
	else:
		$center/bottom/logging.visible = true
		$center/bottom/logging.rect_position = Vector2(-125, -164)
		$center/bottom/loggin_hide_show_button/lbl.text = "x"
		$center/bottom/loggin_hide_show_button.position = Vector2(145, -186)
	pass # Replace with function body.


func _on_enable_logging_toggled(button_pressed):
	logging_enabled = button_pressed
	pass # Replace with function body.


func _on_plotter_timer_timeout():
	$left/bottom/plotters/avg_speed.add_data(Global.avg_speed)
	$left/bottom/plotters/consumption.add_data(Global.avg_energy_consumption)
	$left/bottom/plotters/car_ammount.add_data(Global.cars_ammount)
	pass # Replace with function body.


func _on_no_connection_pressed():
	if Global.current_trafic_light:
		Global.current_trafic_light.lost_connection()
	pass # Replace with function body.


func _on_fail_pressed():
	if Global.current_trafic_light:
		Global.current_trafic_light.broken()
	pass # Replace with function body.


func _on_to_menu_pressed():
	Global.current_repair_evac = null
	Global.current_trafic_light = null
	get_tree().change_scene("res://tscnes/main_menu.tscn")
	pass # Replace with function body.
