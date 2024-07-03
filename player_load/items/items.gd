extends Node2D
class_name items


#this script handles items.
#it handles input to use them
#it interacts with the inventory menu to change what is equipped.
#the inventory menu can access this through the player instance

#TODO: i havent touched this in a while, but. do it more. its pretty important
#TODO: bombs, power bracelet?(I think picking up stuff and pushing stuff will be default)
#TODO: if I make bombs, i might have to add another tile type with a custom save flag 
#TODO: update to save file when an item is switched

enum ItemState {BOOMERANG, BOW, FISH_ROD, BOMB, NONE}

#I'll attach these manually at first, eventually I can add them through code?
signal item_x
signal item_y

#region exports

@export var x_item : ItemState = ItemState.NONE
@export var y_item : ItemState = ItemState.NONE

#item refs
@export var boom_launch : boomerang_launcher
@export var rod_node : fishing_rod
@export var bomb_bag_node : bomb_bag

#endregion

#internals
var items_disabled : bool = false

#region autoloads

#autoloads
@onready var save_fi : save_file = get_node("/root/save_file_auto")
@onready var player_script : player_loader = get_node("/root/player_loader_auto")

#endregion

func _input(event):
	if items_disabled:
		return
	
	if event.is_action_pressed("item_x"):
		check_item(x_item)
	if event.is_action_pressed("item_y"):
		check_item(y_item)

func check_item(i : ItemState):
	#checks the itemstate against all possible values and performs the necessary functions to use that item.
	match i:
		ItemState.BOOMERANG:
			#throw boomerang
			boom_launch.throw_boomerang()
		ItemState.BOW:
			print("bow")
		ItemState.FISH_ROD:
			#the rod should activate pretty much a whole new control scheme, so its going to be a pain... but i think its ok.
			rod_node.toggle_rod()
		ItemState.BOMB:
			bomb_bag_node.place_bomb()

func toggle_items(b : bool) -> void:
	#turns on/off the item input (x/y)
	items_disabled = !b
