extends Node2D
class_name save_file

#so I can load and record the file.
#but how do i change it?
#essentially I want a node I can place that will add certain values to the current_file.
#then another trigger to record those changes.

@export var current_file : file_01

@export var save_dir : Array[String]

@export var file_index : int = 0

#writes the current_file to the save_directory
func record_file(fi : int):
	var dir : DirAccess = DirAccess.open("user://")
	if not dir.dir_exists("save/"):
		dir.make_dir("save/")
	if ResourceSaver.save(current_file, save_dir[fi]) != OK:
		print("save_file could't record the file")

#updates the current file with the one in the directory.
func load_file(fi : int):
	if not FileAccess.file_exists(save_dir[fi]):
		#print("no save file at: ", save_dir[fi], ", creating new file.")
		current_file = file_01.new()
		record_file(fi)
		return
	
	current_file = ResourceLoader.load(save_dir[fi], "file_01")

#checks for the save file in the user directory
func file_exists(fi : int) -> bool:
	if FileAccess.file_exists(save_dir[fi]):
		return true
	else:
		return false
