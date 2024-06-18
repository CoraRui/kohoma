extends Node2D

#this script should direct the inputs from the items menu to change the equipped item in 
#the items script in the player

#TODO: decide which items to load in depending on what the player has access to in the save file.
#TODO: key specific selection. right now it just loads to x...
#TODO: load items from save file on initial start, but when exactly idk

@onready var player_li : player_loader = get_node("/root/player_loader_auto")
@onready var save_fi : save_file = get_node("/root/save_file_auto")
@onready var stat_bi : stat_bar = get_node("/root/stat_bar_auto")

func _on_boomerang_activated():
	#on select of this, or p much any item, update the players x/y item, update the save files selected item, then show that item in the stat bars item slot
	player_li.player_ins.items_node.x_item = items.ItemState.BOOMERANG
	save_fi.current_file.x_item = items.ItemState.BOOMERANG
	stat_bi.update_slot(items.ItemState.BOOMERANG, true)

func _on_bow_activated():
	player_li.player_ins.items_node.x_item = items.ItemState.BOW
	save_fi.current_file.x_item = items.ItemState.BOW
	stat_bi.update_slot(items.ItemState.BOW, true)

func _on_fishing_rod_activated():
	player_li.player_ins.items_node.x_item = items.ItemState.FISH_ROD
	save_fi.current_file.x_item = items.ItemState.FISH_ROD
	stat_bi.update_slot(items.ItemState.FISH_ROD, true)


func _on_bomb_bag_activated():
	player_li.player_ins.items_node.x_item = items.ItemState.BOMB
	save_fi.current_file.x_item = items.ItemState.BOMB
	stat_bi.update_slot(items.ItemState.BOMB, true)
