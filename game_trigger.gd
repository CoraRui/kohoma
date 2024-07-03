extends Node2D


#this node should contain paramters and functions for loading the game between different states.
#meaning things like between title screen, to the file selection, to the main world, to the game over screen, etc.



@export_group("main level load")
#contains parameters for the level load of type "main level"
#meaning the type of load that occurs from the file select.
#so what things would i have to send to the game_loaders load game function?
#and what parts should i take care of within this node?
@export var to_free : Node2D 	#a node in this scene to free on load


