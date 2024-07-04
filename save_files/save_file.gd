extends Node2D
class_name save_file

#so I can load and record the file.
#but how do i change it?
#essentially I want a node I can place that will add certain values to the current_file.
#then another trigger to record those changes.

@export var current_file : file_01			#current referenced file

@export var fail_file : file_01				#file to be loaded if get_file is run without a loaded file

@export var save_dir : Array[String]		

@export var file_index : int = 0

@export var debug_name : String = "save/load"

#autoload

@onready var debug_hi : debug_helper = get_node("/root/debug_helper_auto")

#writes the current_file to the save_directory
func record_file(fi : int):
	var dir : DirAccess = DirAccess.open("user://")
	if not dir.dir_exists("save/"):
		dir.make_dir("save/")
	if ResourceSaver.save(current_file, save_dir[fi]) != OK:
		debug_helper.db_message("save_file could't record the file", debug_name)

func load_file(fi : int) -> void:
	#updates the current file with the one in the directory. doesn't return the file. use get_current
	if not FileAccess.file_exists(save_dir[fi]):
		debug_helper.db_message("no save file at: " + save_dir[fi] + ", creating new file.", debug_name)
		current_file = file_01.new()
		record_file(fi)
		return
	
	current_file = ResourceLoader.load(save_dir[fi], "file_01")		#loads the file
	file_index = fi													#notes the index of the currently loaded file

func file_exists(fi : int) -> bool:
	#checks for the save file in the user directory
	if FileAccess.file_exists(save_dir[fi]):
		return true
	else:
		return false

func get_file() -> file_01:
	#gets the current file, returns the fail file if there isn't one loaded.
	#use load_file first.
	if current_file:
		return current_file
	else:
		return fail_file
	
	
	
	
	
	
	
