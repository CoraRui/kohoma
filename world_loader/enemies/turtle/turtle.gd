extends Node2D


#the basic type of movement that I'm usig is the vector array.
#the movement function uses one index of the vec_arr in order to determine how far to move.
#the matrix of movement states determines which array to use, and in which direction to go based on the 
#current movement state, and the inner workings of that state.

#for turtle, I want to go with 16 pixel tile movement relative to the 
#ready function should lock position in to nearest 16x16 point.

#TODO: add collision responses
#TODO: add health and hurt movement responses
#TODO: add random movement scheme for walking
#TODO: add invincibility while shelled


#ok, I'm thinking this could be something like it goes "in its shell" when the player approaches.
#meaning you either have to smash it or hit it at a range its not defending.
#feels like per tile movement would be ideal. I can just have it track multiples of 16 relative to global origin.

#enums
#describes the possible types of movement
enum MoveState {WALKING, SHELLED, HURT}
var move_state : MoveState = MoveState.WALKING

#describes the possible directions of movement within "WALKING"
enum WalkDir {UP, DOWN, LEFT, RIGHT}
var walk_dir : WalkDir = WalkDir.DOWN

#possible directions withing "HURT"
enum HurtDir {UP, DOWN, LEFT, RIGHT, STOP}
var hurt_dir : HurtDir = HurtDir.UP

#each frame, the move_frame function uses one index from the vel_arr for the current movement state to 
#determine how far to move the enemy.
@export_group("movement")
@export var walk_vel_arr : Array[int] = [1]
@export var hurt_vel_arr : Array[int] = [1]
@export_group("","")


#movement variables
var move_index : int = 0 #tracks which frame in the movement pattern to use.

func _ready():
	#sets initial position to multiple of 16 on tilemap
	global_position = Vector2(global_position.x - int(global_position.x) % 16, global_position.y - int(global_position.y) % 16)
	print(global_position)

func _process(_delta):
	move_frame()
	

func move_frame():
	#determines how the enemy should move this frame.
	if move_state == MoveState.WALKING:
		if move_index >= walk_vel_arr.size():
			move_index = 0
		if walk_dir == WalkDir.UP:
			position += Vector2(0, -walk_vel_arr[move_index])
		if walk_dir == WalkDir.DOWN:
			position += Vector2(0, walk_vel_arr[move_index])
		if walk_dir == WalkDir.LEFT:
			position += Vector2(-walk_vel_arr[move_index], 0)
		if walk_dir == WalkDir.RIGHT:
			position += Vector2(walk_vel_arr[move_index], 0)
	if move_state == MoveState.HURT:
		if hurt_dir != HurtDir.STOP:
			if move_index >= hurt_vel_arr.size():
				move_index = 0
			if walk_dir == WalkDir.UP:
				position += Vector2(0, -hurt_vel_arr[move_index])
			if walk_dir == WalkDir.DOWN:
				position += Vector2(0, hurt_vel_arr[move_index])
			if walk_dir == WalkDir.LEFT:
				position += Vector2(-hurt_vel_arr[move_index], 0)
			if walk_dir == WalkDir.RIGHT:
				position += Vector2(hurt_vel_arr[move_index], 0)
	if move_state == MoveState.SHELLED:
		#this might actually be it. its not supposed to move...
		pass
	
	#update move_index for next frame
	move_index += 1











