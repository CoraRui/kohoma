extends Node2D
class_name to_next

#temporary thing that literally just instantiates the attached node and eliminates the old one.


@export_group("node refs")
#node to replace old on.
@export var ins : PackedScene 
#node to be freed
@export var del : Node2D
@export_group("","")

@export_group("triggers")
#activate this to switch the world as soon as this node loads
@export var useready : bool = true
@export var useinput : bool = true 
@export_group("","")

func _ready():
	if useready:
		switch()

func _input(event):
	if useinput && event.is_action_pressed("start"):
		switch()
		
func switch():
	if ins:
		var new_node : Node2D = ins.instantiate()
		get_tree().get_root().add_child.call_deferred(new_node)
	if del:
		del.queue_free()
