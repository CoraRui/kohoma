extends Node2D
class_name catch_point

#contains information for the catch node. mainly just the catch point itself.

#should be good for handling behavior in the objects this attaches to.
signal caught
signal released


@export var catch_target : Node2D
