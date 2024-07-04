extends Resource
class_name file_01

#TODO: I think this would be a good spot for getters/setters or get set functions for these variables. maybe. idk.
#anyways I have to find a way to do all that. cause I COULD just do everything manually from every time
#I add anything, but. thats a pain. itd probably be betted to just have a getter setter for the keys for instance
#to update the stat bar with its values. or even a specific function for doing so.

#this resource contains values for the players save file.

#region player_information
@export var player_name : String = "player"

@export var character_name : String = "flea"

@export var hp : int = 12

@export var mhp : int = 12

@export var keys : int = 0
#endregion

#inventory

#region inventory
@export var gold : int = 0

@export var x_item : items.ItemState = items.ItemState.NONE

@export var y_item : items.ItemState = items.ItemState.NONE
#endregion

#general records

@export var kills : int = 0

#events - the event dictionary holds a list of usually booleans that usuall refer to story events.
#each event_trigger node will have a string label which determines whether the node will actually load in its 
#scripted event.

#region event flags
@export var event_dict : Dictionary = {
	"test_event" : true
}

@export var clean_file : bool = true

@export var proto_flag : bool = true		#causes the world to just load normally. start at the house.

@export var fail_flag : bool = false		#indicates that theres some problem with the file. loads a fail screen

#endregion


#so how will i determine where the player will load?
#for now its just going to happen at the house. i can figure out more later.
