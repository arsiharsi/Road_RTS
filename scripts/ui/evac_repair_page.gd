extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
var curr

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	visible = Global.current_repair_evac != null
	if Global.current_repair_evac:
		curr = Global.current_repair_evac
		$labels/name.text = curr.name
		if curr.is_active:
			$labels/state.text = "Занят"
			$labels/state.modulate = Color.red
		else:
			$labels/state.text = "Свободен"
			$labels/state.modulate = Color.green
		$labels/distance_to_point.text = str(stepify(curr.global_position.distance_to(Global.camera_node.global_position), 0.1))+" m"
		
	pass


func _on_close_pressed():
	Global.current_repair_evac = null
	pass # Replace with function body.


func _on_send_car_pressed():
	Global.current_repair_evac.call_service(Global.camera_node.global_position)
	pass # Replace with function body.
