extends Node
class_name Direction

#contains the direction enum for the player.

enum Bearing {UP = 0, DOWN = 1, LEFT = 2, RIGHT = 3}

#add a function for attributing a unit vector to a direction

func get_uvec(b : Bearing) -> Vector2:
	if b == Bearing.UP:
		return Vector2(0,-1)
	elif b == Bearing.DOWN:
		return Vector2(0,1)
	elif b == Bearing.LEFT:
		return Vector2(-1,0)
	elif b == Bearing.RIGHT:
		return Vector2(1,0)
	else:
		print("bearing did something weird")
		return Vector2(0,0)
	
