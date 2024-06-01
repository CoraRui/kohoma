extends Node2D
class_name file_tester

#this script should display the values in the save file when row one is pressed

@onready var save_fi : save_file = get_node("/root/save_file_auto")

func _input(event):
	if event.is_action_pressed("print_file"):
		print_file()
	
func print_file():
	print("player name: ", save_fi.current_file.player_name)
	print("file clean: ", save_fi.current_file.clean_file)
	print("player money: ", save_fi.current_file.gold)
	print("player kills: ", save_fi.current_file.kills)
	print("event_triggers: ")
	for ek in save_fi.current_file.event_dict.keys():
		print("   ", ek, " : ", save_fi.current_file.event_dict[ek])

