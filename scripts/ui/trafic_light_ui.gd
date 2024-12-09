extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var t_light = Global.current_trafic_light
	if t_light:
		set_cheks(t_light.type_way)
		$labels/name.text = str(t_light.name)
		$labels/state.text = get_state(t_light.state)[0]
		$labels/state.modulate = get_state(t_light.state)[1]
		$labels/time_left.text = str(int(t_light.time_left_leg))
		$labels/count_horiz.text = str(t_light.hor_count)
		$labels/count_vert.text = str(t_light.vert_count)
		$labels/count_overall.text = str(t_light.vert_count+t_light.hor_count)
		# CHECKS
		
	pass

#"working", "no_connection", "fail"

func get_state(in_state):
	if in_state == "working":
		return ["Работает", Color.green]
	if in_state == "no_connection":
		var time_left = int(Global.current_trafic_light.reconect_time_left)
		if time_left == 0:
			return ["Нет связи", Color.yellow]
		else:
			return ["Переподключение: "+str(time_left), Color.cyan]
	if in_state == "fail":
		return ["Крит. ошибка", Color.red]
	pass

# "both","main","slave"
func set_cheks(in_type):
	var cl = {"both":"cross","main":"horiz","slave":"vert"}
	get_node("checks/"+cl[in_type]).visible = true
	for i in range(0, $checks.get_child_count()):
		if $checks.get_child(i).name != cl[in_type]:
			$checks.get_child(i).visible = false
	pass


func _on_cross_pressed():
	var t_light = Global.current_trafic_light
	if t_light:
		t_light.type_way = "both"
		t_light.reset_lights()
	pass # Replace with function body.


func _on_horiz_pressed():
	var t_light = Global.current_trafic_light
	if t_light:
		t_light.type_way = "main"
	pass # Replace with function body.


func _on_vert_pressed():
	var t_light = Global.current_trafic_light
	if t_light:
		t_light.type_way = "slave"
	pass # Replace with function body.


func _on_reconnect_pressed():
	var t_light = Global.current_trafic_light
	if t_light:
		t_light.start_reconnect()
	pass # Replace with function body.
