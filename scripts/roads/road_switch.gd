extends Area2D

export(Array, NodePath) var next_road_swithces
export(Array, NodePath) var prioritized_road_swithces

func get_class():
	return "road_switch"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func redraw():
	if next_road_swithces.size() != 0:
		for i in range(0, next_road_swithces.size()-$road_visualisers.get_child_count()):
			$road_visualisers.add_child($road_visualisers.get_child(0).duplicate())
		if $road_visualisers.get_child_count() > next_road_swithces.size() and next_road_swithces.size() != 0:
			for i in range(0, $road_visualisers.get_child_count() - next_road_swithces.size()):
				$road_visualisers.get_child(i).queue_free()
		if $road_visualisers.get_child_count() == next_road_swithces.size():
			for i in range(0, next_road_swithces.size()):
				var road_switch_node = get_node(next_road_swithces[i])
#				print(name + ' '+str(road_switch_node.global_position-global_position))
				$road_visualisers.get_child(i).set_point_position(1,road_switch_node.global_position-global_position)

func recheck_roads():
	for i in range(0, next_road_swithces.size()):
		if not get_node(next_road_swithces[i]).is_inside_tree():
			next_road_swithces.remove(i)

# Called when the node enters the scene tree for the first time.
func _ready():
	recheck_roads()
	redraw()
	pass # Replace with function body.


func get_next_road_swithces():
	var ret = []
	if next_road_swithces.size() != 0:
		for i in range(0, next_road_swithces.size()):
			ret.append(get_node(next_road_swithces[i]))
		return ret
	else:
		return null

func get_prioritazed_swithces():
	var ret = []
	if prioritized_road_swithces.size() != 0:
		for i in range(0, prioritized_road_swithces.size()):
			ret.append(get_node(prioritized_road_swithces[i]))
		return ret
	else:
		return get_next_road_swithces()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_road_switch_body_entered(body):
	if body.has_method("get_class"):
		if body.get_class() == "car" and not body.prioritizing:
			var new_switches = get_next_road_swithces()
			var new_road = new_switches[int(rand_range(0, new_switches.size()))].global_position
			body.set_new_pos(new_road)
		elif body.get_class() == "car":
			var new_switches = get_prioritazed_swithces()
			var new_road = new_switches[int(rand_range(0, new_switches.size()))].global_position
			body.set_new_pos(new_road)
		body.global_position = global_position
	pass # Replace with function body.
