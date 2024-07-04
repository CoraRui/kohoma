extends Node2D
class_name game_trigger

#this node should contain paramters and functions for loading the game between different states.
#meaning things like between title screen, to the file selection, to the main world, to the game over screen, etc.
#so this is just the trigger. it just contains the variables to tell the game how to load, and calls the game loader.

@export var to_free : Node2D 						#a node in this scene to free on load

#region autoloads

@onready var game_li : game_loader = get_node("/root/game_loader_auto")

#endregion

func load_main(fi : int):
	#uses the file index from the ui signal to trigger the game_loader autoload.
	#the game_loader will use that file to determine how to load the game.
	game_li.load_game(fi)
	
	if to_free:
		to_free.queue_free()

#file select signals

func _on_file_one_activated():
	load_main(0)

func _on_file_two_activated():
	load_main(1)

func _on_file_three_activated():
	load_main(2)
