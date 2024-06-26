extends Node2D
class_name pot

#ok. im trying to think about just liftables in general.

#you can lift them. you can throw them.
#i think I'll design pot to be the liftable script.

#also want to think about button assignment. pretty sure that it will be combined with the confirm button.
#confirm will probably take precedence.


@export var pot_target : Node2D		#target for positional translation with the player and throwing movement

@export var lift_spot : Node2D		#spot the player will be moved to when lifting/grabbing the pot if applicable
									#possibly only bind to an axis if its like a wall or something.

#signals
signal grabbed		#when the player first grabs the pot
signal pulled		#when the player uses the directional arrow opposite the pot
signal lifted		#when the player pulls on the pot successfully lifting it
signal thrown		#when the player throws the pot after lifting it.
signal landed		#when the pot lands on the ground








