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


enum ItemState {BOOMERANG, BOW, ROD, NONE}

#I'll attach these manually at first, eventually I can add them through code?
signal item_x
signal item_y

@export var x_item : ItemState = ItemState.NONE
@export var y_item : ItemState = ItemState.NONE

#item refs
@export var boom_launch : boomerang_launcher
@export var rod_node : fishing_rod

@onready var player_script : player = get_parent()

#autoloads
@onready var save_fi : save_file = get_node("/root/save_file_auto")



func _input(event):
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
		ItemState.ROD:
			#the rod should activate pretty much a whole new control scheme, so its going to be a pain... but i think its ok.
			rod_node.activate_rod()


