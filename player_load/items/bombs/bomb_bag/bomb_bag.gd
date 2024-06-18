extends Node2D
class_name bomb_bag

#bomb bag. drop bombs on press.
#I think I'll just have them appear on a certain location. no hold and throw. too hard...
#for now, not even directional placement. just put them at the position of the point.

@export var bomb_point : Node2D

@export var bomb_node : PackedScene		#actual bomb thing to drop

@onready var world_i : world = get_node("/root/world_auto")

func place_bomb():
	var new_bomb : Node2D = bomb_node.instantiate()
	world_i.current_level.add_child(new_bomb)
	new_bomb.global_position = global_position
	



