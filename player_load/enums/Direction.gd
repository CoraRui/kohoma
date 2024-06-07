extends Node
class_name DirClass

#contains the direction enum for the player.

enum Dir {UP = 0, DOWN = 1, LEFT = 2, RIGHT = 3, NONE = 4}

#add a function for attributing a unit vector to a direction

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
