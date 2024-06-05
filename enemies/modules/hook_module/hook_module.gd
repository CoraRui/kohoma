extends Node2D
class_name hook_module


#this should be attached to enemies or objects in order to determine the effects of being hooked.
#so when an enemy is in a hooked state, there are a couple of things to consider
#the effect of simply being hooked
#the effect of pulling
#pulling will usually steal an item that the enemy has or take something from it.
#the effect of reeling
#in general reeling pulls the enemy closer to you

signal hook

signal pull
signal relax

signal reel
signal stop_reel

@export var hook_point : Node2D

#determines the height of the bobber
@export var y_loc : bobber.YLoc = bobber.YLoc.LOW
