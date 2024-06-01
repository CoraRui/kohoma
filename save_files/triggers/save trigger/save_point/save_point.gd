extends Node2D

#the save point allows the player to save when they are standing on it.
@onready var save_fi : save_file = get_node("/root/save_file_auto")
@onready var stat_bi : stat_bar = get_node("/root/stat_bar_auto")

@export var save_area : Area2D

func _input(event):
	if event.is_action_pressed("start") && save_area.has_overlapping_areas():
		save()

func save():
	save_fi.record_file(save_fi.file_index)
	#debug
	save_fi.load_file(save_fi.file_index)
	print(save_fi.current_file.character_name)

func _on_save_area_area_entered(_area):
	stat_bi.update_flav_text("press enter to save", "")
	
func _on_save_area_area_exited(_area):
	stat_bi.update_flav_text("", "")

