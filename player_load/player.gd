extends Node2D
class_name player

#collects information for other scripts to reference to avoid having to access children.

var direction : dir_auto.Bearing = dir_auto.Bearing.DOWN

@export var items_node : items



#so item use. how do I enable and disable certain items based on what is equipped?
#have "launcher" nodes in the player and simply enable and disable them by having an input script in the player overall script which chooses which to use.


#have an items node which handles all items as its children, contains references to them etc.
#load the item nodes in and out dynamically by interacting with the inventory menu.
#have that "items" node control input as well.

