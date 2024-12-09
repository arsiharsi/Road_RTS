extends Area2D

var cars_array = []
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_parking_body_entered(body):
	if body.has_method("get_class"):
		if body.get_class() == "car":
			cars_array.append(body)
			body.in_parking(self)
	pass # Replace with function body.


func _on_parking_body_exited(body):
	if body.has_method("get_class"):
		if body.get_class() == "car":
			cars_array.erase(body)
	pass # Replace with function body.
