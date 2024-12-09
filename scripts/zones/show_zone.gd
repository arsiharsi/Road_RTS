extends ColorRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if get_parent():
		var x = get_parent().shape.extents.x
		var y = get_parent().shape.extents.y
		margin_left = -x
		margin_right = x
		margin_top = -y
		margin_bottom = y 
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
