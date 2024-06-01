extends Resource
class_name level

#this resource contains all necessary info for a certain level in the world_tree.
#right now its just a node2d to instantiate. but I feel like its prudent to have this in case
#more needs arise. like I could add music triggers here, or player load triggers etc.

@export var level_node : PackedScene
