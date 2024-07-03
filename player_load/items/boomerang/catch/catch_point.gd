extends Node2D
class_name catch_point

#TODO: should number of catches be listed here to prevent picking up multiple items?
#contains information for the catch node. mainly just the catch point itself.

#should be good for handling behavior in the objects this attaches to.
signal caught
signal released


@export var catch_target : Node2D


func _on_boomerang_caught_boomerang():
	released.emit()
