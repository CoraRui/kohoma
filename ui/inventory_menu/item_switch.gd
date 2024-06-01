extends Node2D

#this script should direct the inputs from the items menu to change the equipped item in 
#the items script in the player

#TODO: decide which items to load in depending on what the player has access to in the save file.

@onready var player_li : player_loader = get_node("/root/player_loader_auto")

func _on_boomerang_activated():
	player_li.player_ins.items_node.x_item = items.ItemState.BOOMERANG

func _on_bow_activated():
	player_li.player_ins.items_node.x_item = items.ItemState.BOW
