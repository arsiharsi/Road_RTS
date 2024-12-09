extends Area2D

export var acceptable_speed = 60
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$start/lbl.text = str(acceptable_speed)
	$end/lbl.text = str(acceptable_speed)
	if get_child_count() == 3:
		if get_child(2).get_child_count() >= 2:
			$start.global_position = get_child(2).get_child(0).global_position
			$end.global_position = get_child(2).get_child(1).global_position
	pass


func _on_speed_limit_zone_body_entered(body):
	if body.has_method("get_class"):
		if body.get_class() == "car":
			body.set_new_speed(acceptable_speed)
	pass # Replace with function body.


func _on_speed_limit_zone_body_exited(body):
	if body.has_method("get_class"):
		if body.get_class() == "car":
			body.reset_speed()
	pass # Replace with function body.
