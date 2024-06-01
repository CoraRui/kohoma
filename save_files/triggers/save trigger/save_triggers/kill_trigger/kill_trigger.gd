extends Node2D


#this script updates the killcount when the attached enemy dies

@export var kill_count : int = 1

@onready var save_fi : save_file = get_node("/root/save_file_auto")

func add_kill():
	save_fi.current_file.kills += kill_count
	
