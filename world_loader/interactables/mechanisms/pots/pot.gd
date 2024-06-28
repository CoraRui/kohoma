extends Node2D
class_name pot

#ok. im trying to think about just liftables in general.

#when you pull on this object, what happens?
#does it drag on the floor? does it lift? does it only lift if you have the 
#strong lift upgrade? 
enum PullType {PULL, HEAVY_PULL, LIFT, HEAVY_LIFT, STATIC}
@export var pull_type : PullType = PullType.STATIC


#you can lift them. you can throw them.
#i think I'll design pot to be the liftable script.

#also want to think about button assignment. pretty sure that it will be combined with the confirm button.
#confirm will probably take precedence.


@export var pot_target : Node2D		#target for positional translation with the player and throwing movement

@export var lift_point : Node2D		#spot the player will be moved to when lifting/grabbing the pot if applicable
									#possibly only bind to an axis if its like a wall or something.


@export_group("sfx")
#unique sfx for the pot. ill try to have a default set though.
#booleans determine whether to use custom or default
@export var use_grab_sf : bool = false
@export var grab_sf : sf_link
@export var use_throw_sf : bool = false
@export var throw_sf : sf_link
@export_group("","")

#signals
signal grabbed		#when the player first grabs the pot
signal pulled		#when the player uses the directional arrow opposite the pot
signal lifted		#when the player pulls on the pot successfully lifting it
signal thrown		#when the player throws the pot after lifting it.
signal landed		#when the pot lands on the ground


func throw():
	#this function starts the throw movement for the pot.
	pass





