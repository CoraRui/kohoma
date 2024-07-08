extends Node2D
class_name world_tree

#this script attaches to the world tree node.
#this node contains a number of Node2D children with children of type level slot.
#this forms a 2d array containing all of the levels in a single "world"
#this script contains functions with which to reference those levels.

@export var fail_level : level

func get_level_at(lp : Vector2i) -> level:
	#returns the level at the location lp.
	#by convention, the   notation is (x,y), x = immediate child, y = level_slot(second child)
	if lp.x < get_child_count() && lp.y < get_child(0).get_child_count():
		var found_level : level = get_child(lp.x).get_child(lp.y).level_ref
		
		#checks that the level isn't blank
		if found_level:
			return found_level
		else:
			debug_helper.db_message("get_level_at was called on a position containing a null level value. returning failsafe", "world_tree")
			return fail_level
	else:
		debug_helper.db_message("get_level_at was called on an invalid value in: " + name + ". returning failsafe", "world_tree")
		return fail_level

