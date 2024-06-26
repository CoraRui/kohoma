extends Node
class_name DirClass

#contains the direction enum for the player.

enum Dir {UP = 0, DOWN = 1, LEFT = 2, RIGHT = 3, NONE = 4}

#add a function for attributing a unit vector to a direction

static func get_dir(v : Vector2) -> Dir:
	#this function returns
	var dir : Dir
	
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

#after all this time im still trying to figure out how to move in four directions... ugh.
#i want to be able to turn directional input into a direction(Dir)
#in the player lift thing, im gonna have movement states. which i want to update based on input
#but it feels like I do that a lot.

