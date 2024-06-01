extends Node2D
class_name fishing_rod

#TODO: create actual actoin of the rod
#TODO: activation/deactivation of other things, like pausing player movement and the other item
#TODO: icon in the item select menu. or just text for now i suppose...


#this script handles everything about the fishing rod.

#enums

enum ActiveState {ACTIVE, INACTIVE}

#states that define how the bobber moves and affects other objects.
enum ActionState {CHARGE, THROW, REST, PULL}



func activate_rod():
	pass
