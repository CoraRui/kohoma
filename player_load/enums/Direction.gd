extends Node
class_name DirClass

#contains the direction enum for the player.

enum Dir {UP = 0, DOWN = 1, LEFT = 2, RIGHT = 3, NONE = 4}

#add a function for attributing a unit vector to a direction

static func udlr_to_dir(i : int) -> Dir:
	#converts 0,1,2,3 to up,down,left, or right. considering doing other integers cyclically. like 4=0=up and so on.
	match i % 3:
		0:
			return Dir.UP
		1:
			return Dir.DOWN
		2:
			return Dir.LEFT
		3:
			return Dir.RIGHT
		_:
			return Dir.NONE
	
static func dir_to_udlr(d : Dir) -> int:
	match d:
		Dir.UP:
			return 0
		Dir.DOWN:
			return 1
		Dir.LEFT:
			return 2
		Dir.RIGHT:
			return 3
		Dir.NONE:
			return 4
		_:
			return -1
	
static func get_dir(v : Vector2) -> Dir:	
	if v.x == 0:
		if v.y == 0:
			return Dir.NONE
		elif v.y < 0:
			return Dir.UP
		else:
			return Dir.DOWN
	elif v.y == 0:
		if v.x > 0:	return Dir.RIGHT
		else:	return Dir.LEFT
	else:
		return Dir.NONE

static func get_uvec(b : Dir) -> Vector2:
	if b == Dir.UP:
		return Vector2(0,-1)
	elif b == Dir.DOWN:
		return Vector2(0,1)
	elif b == Dir.LEFT:
		return Vector2(-1,0)
	elif b == Dir.RIGHT:
		return Vector2(1,0)
	else:
		print("bearing did something weird")
		return Vector2(0,0)
	
static func get_flip(d : Dir) -> Dir:
	match d:
		Dir.UP:
			return Dir.DOWN
		Dir.DOWN:
			return Dir.UP
		Dir.LEFT:
			return Dir.RIGHT
		Dir.RIGHT:
			return Dir.LEFT
		_:
			print("flip wasnt in a direction, is that bad?")
			return Dir.NONE

static func input_to_dir(e : InputEvent) -> Dir:
	#takes an input event, translates up down left right into directions.
	if e.is_action_pressed("up"):
		return Dir.UP
	if e.is_action_pressed("down"):
		return Dir.DOWN
	if e.is_action_pressed("left"):
		return Dir.LEFT
	if e.is_action_pressed("right"):
		return Dir.RIGHT
	debug_helper.db_message("input to dir returned none. intentional?", "direction")
	return Dir.NONE
	
static func are_opposite(d1 : Dir, d2 : Dir) -> bool:
	#returns true if the directions are opposite(left/right, up/down)
	
	if d1 == Dir.UP && d2 == Dir.DOWN:
		return true
	if d1 == Dir.DOWN && d2 == Dir.UP:
		return true
	if d1 == Dir.LEFT && d2 == Dir.RIGHT:
		return true
	if d1 == Dir.RIGHT && d2 == Dir.LEFT:
		return true
	
	return false
	

#after all this time im still trying to figure out how to move in four directions... ugh.
#i want to be able to turn directional input into a direction(Dir)
#in the player lift thing, im gonna have movement states. which i want to update based on input
#but it feels like I do that a lot.

