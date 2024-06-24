extends Node2D


#how should the wall detect the bombs collisions?
#probably the bombs will check for bomb walls

@export var save_flag : String = "bomb_wall_xxx"	#string representing if the wall is broken

#autoloads
@onready var save_fi : save_file = get_node("/root/save_file_auto")

func _ready():
	#check the save file to see if the wall is "gone"
	if save_fi.current_file.event_dict.has(save_flag):
		if save_fi.current_file.event_dict[save_flag]:
			queue_free()

func destroy_wall():
	#update the save file to prevent load next time
	save_fi.current_file.event_dict[save_flag] = true
	#destroy the wall
	queue_free()

func _on_wall_area_area_entered(_area):
	#area on layer explosion detected
	destroy_wall()

