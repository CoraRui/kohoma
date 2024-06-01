extends Node2D

#this script writes over the players current event dictionary with the values in this one.
#it also may delete itself if its values match the dictionary


@onready var save_fi : save_file = get_node("/root/save_file_auto")

@export var add_dict : Dictionary

#if true, marks the events as recorded when the game starts.
@export var onready : bool = false

@export_multiline var notes : String 

#condition
@export var condition : String = ""

@export var condition_active : bool = false

func _ready():
		
	if condition_active:
		if save_fi.current_file.event_dict.has(condition):
			if save_fi.current_file.event_dict[condition]:
				queue_free()
	if onready:
		record_events()


func record_events():
	for k in add_dict.keys():
		save_fi.current_file.event_dict[k] = add_dict[k]
