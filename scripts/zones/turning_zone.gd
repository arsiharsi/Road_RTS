extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_turning_zone_body_entered(body):
	if body.has_method("get_class"):
		if body.get_class() == "car":
			body.turning_mode()
	pass # Replace with function body.


func _on_turning_zone_body_exited(body):
	if body.has_method("get_class"):
		if body.get_class() == "car":
			body.reset_turning_mode()
	pass # Replace with function body.
