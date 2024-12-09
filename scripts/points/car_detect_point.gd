extends Sprite

var target
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if target:
		if "sprite_rotation" in target:
			global_rotation = target.sprite_rotation
		global_position = target.global_position
		
	pass
