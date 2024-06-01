extends Node2D
class_name items


#this script handles items.
#it handles input to use them
#it interacts with the inventory menu to change what is equipped.
#the inventory menu can access this through the player instance

#TODO: bombs, power bracelet?(I think picking up stuff and pushing stuff will be default)
#TODO: if I make bombs, i might have to add another tile type with a custom save flag 


enum ItemState {BOOMERANG, BOW}

#I'll attach these manually at first, eventually I can add them through code?
signal item_x
signal item_y

@export var x_item : ItemState = ItemState.BOOMERANG
@export var y_item : ItemState = ItemState.BOW

#item refs
@export var boom_launch : boomerang_launcher


func _input(event):
	if event.is_action_pressed("item_x"):
		check_item(x_item)
	if event.is_action_pressed("item_y"):
		check_item(y_item)

func check_item(i : ItemState):
	#checks the itemstate against all possible values and performs the necessary functions to use that item.
	if i == ItemState.BOOMERANG:
		#throw boomerang
		boom_launch.throw_boomerang()
	if i == ItemState.BOW:
		print("bow")


