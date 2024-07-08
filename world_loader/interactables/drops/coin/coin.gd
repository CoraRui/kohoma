extends Node2D

#this script is the base object for a coin node.
#the coin node is a coin drop that the player can pick up.
#the most basic features are that the player can touch it and it will add to their inventory.
#should also have sound effects, expiration time, probably more.
#also theres modified drop rate based on player status, but thats going to be more of a drop module thing.

#this node actually wont appear alone. itll be used in a larger node that has different parameters.
#wait but i can't change animations that way...

@export var value : int = 1

@export var pickup_sn : sf_link

#region autoloads

@onready var save_fi : save_file = get_node("/root/save_file_auto")
@onready var sfx_pi : sfx_player = get_node("/root/sfx_player_auto")

#endregion

func add_coin() -> void:
	#main function. adds coin to inventory and destroys self node.
	save_fi.current_file.gold += value		#add coins value to save file
	sfx_pi.play_sound(pickup_sn.sf_name)	#play sound effect
	queue_free()							#destroy the coin

func _on_coin_area_area_entered(_area):
	add_coin()
