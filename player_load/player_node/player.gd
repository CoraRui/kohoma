extends Node2D
class_name player

#collects information for other scripts to reference to avoid having to access children.

var direction : DirClass.Dir = DirClass.Dir.DOWN

@export var items_node : items

@export var movement_script : player_movement
@export var sword_script : sword

func set_movement(f : bool):
	if f:
		movement_script.unfreeze()
	else:
		movement_script.freeze()

func set_sword_active(s : bool):
	sword_script.set_sword_active(s)

#so item use. how do I enable and disable certain items based on what is equipped?
#have "launcher" nodes in the player and simply enable and disable them by having an input script in the player overall script which chooses which to use.


#have an items node which handles all items as its children, contains references to them etc.
#load the item nodes in and out dynamically by interacting with the inventory menu.
#have that "items" node control input as well.

