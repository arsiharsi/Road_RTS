extends Node2D

var target_position = Vector2.ZERO
var importance = 1
var text = ""
var parts_scene = load("res://tscnes/UI/notif_parts.tscn")
var parts 
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.misc_node:
		parts = parts_scene.instance()
		Global.misc_node.add_child(parts)
		parts.global_position = target_position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var imp = [Color.green, Color.yellow, Color.red][importance]
	if parts:
		parts.global_position = target_position
		parts.modulate = imp
	if get_parent().get_child(0) == self:
		position = Vector2.ZERO
		visible = true
	else:
		visible = false
		position = Vector2(0,800)
	modulate = imp
	$txt.text = text
	pass


func _on_button_pressed():
	if Global.camera_node:
		Global.camera_node.global_position = target_position
	$def.play("def")
	pass # Replace with function body.

func end():
	if parts:
		parts.queue_free()
	queue_free()
