extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $center/center/car_ammount.text.is_valid_integer():
		$center/center/car_ammount.modulate = Color.white
	else:
		$center/center/car_ammount.modulate = Color.red
	pass


func _on_to_main_pressed():
	if $center/center/car_ammount.text.is_valid_integer():
		Global.in_cars_ammount = int($center/center/car_ammount.text)
		get_tree().change_scene("res://tscnes/locations/main.tscn")
	pass # Replace with function body.


func _on_to_test_pressed():
	get_tree().change_scene("res://tscnes/locations/test.tscn")
	pass # Replace with function body.
