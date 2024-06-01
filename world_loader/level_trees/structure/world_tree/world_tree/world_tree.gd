extends Node2D
class_name world_tree

#this script contains info for a world tree.
#it contains functions to access its children.

@export var fail_level : level

func get_level_at(lp : Vector2i) -> level:
	#returns a level at the position lp
	#checks for boundaries
	if lp.x < get_child_count() && lp.y < get_child(0).get_child_count():
		var found_level : level = get_child(lp.x).get_child(lp.y).level_ref
		
		#checks that the level isn't blank
		if found_level:
			return found_level
		else:
			print("get_level_at was called on a position containing a null level value. returning failsafe")
			return fail_level
	else:
		print("get_level_at was called on an invalid value in: ", name, ". returning failsafe")
		return fail_level
		
