extends Node2D


#the basic type of movement that I'm usig is the vector array.
#the movement function uses one index of the vec_arr in order to determine how far to move.
#the matrix of movement states determines which array to use, and in which direction to go based on the 
#current movement state, and the inner workings of that state.

#for turtle, I want to go with 16 pixel tile movement relative to the 
#ready function should lock position in to nearest 16x16 point.

#TODO: WHY THE FUCK DID YOU USE A TARGET POINT LMAO
#TODO: add wall /other collision responses
#TODO: add health and hurt movement responses
#TODO: add invincibility while shelled
#TODO: flip animation left/right


#ok, I'm thinking this could be something like it goes "in its shell" when the player approaches.
#meaning you either have to smash it or hit it at a range its not defending.
#feels like per tile movement would be ideal. I can just have it track multiples of 16 relative to global origin.

#enums
#describes the possible types of movement
enum MoveState {WALK, SHELLED, HURT}
var move_state : MoveState = MoveState.WALK

var walk_dir : DirClass.Dir = DirClass.Dir.DOWN

#possible directions withing "HURT"
enum HurtDir {UP, DOWN, LEFT, RIGHT, STOP}
var hurt_dir : DirClass.Dir = DirClass.Dir.UP

#region exports

@export_group("animation")
@export var turtle_anim : AnimatedSprite2D
@export_group("","")

#each frame, the move_frame function uses one index from the vel_arr for the current movement state to 
#determine how far to move the enemy.
@export_group("movement")
@export var walk_vel_arr : Array[int] = [1]
@export var hurt_vel_arr : Array[int] = [1]
@export var snap_tol : int = 3
@export var walk_timer : Timer 			#delay before starting to walk after player leaves shell area
@export_group("","")

#endregion

#autoloads
@onready var debug_hi : debug_helper = get_node("/root/debug_helper_auto")

#movement variables
var move_index : int = 0 #tracks which frame in the movement pattern to use.
var target_point : Vector2

func _ready():
	#sets initial position to multiple of 16 on tilemap
	global_position = Vector2(global_position.x - int(global_position.x) % 16, global_position.y - int(global_position.y) % 16)
	target_point = global_position
	check_for_rand()

func _physics_process(_delta):
	walk_move()
	check_for_rand()

func find_state():
	match move_state:
		MoveState.WALK:
			walk_move()
		MoveState.SHELLED:
			pass

func rand_dir():
	var up : int = 25
	var down : int = 25
	var left : int = 25
	var right : int = 25
	
	var r : int = randi_range(0, up+down+left+right)
	
	r -= up
	if r < 0:
		walk_dir = DirClass.Dir.UP
		r += 1000
	r -= down
	if r < 0:
		walk_dir = DirClass.Dir.DOWN
		r += 1000
	r-= left
	if r < 0:
		walk_dir = DirClass.Dir.LEFT
		r += 1000
	r -= right
	if r < 0:
		walk_dir = DirClass.Dir.RIGHT
		r += 1000
		
func check_for_rand():
	#checks if the turtle has reached the target point. if so, it randomizes direction and generates a  new target point
	if global_position.distance_to(target_point) < snap_tol:
		global_position = target_point
		rand_dir()
		var tvec : Vector2 = Vector2(0,0)
		match walk_dir:
			DirClass.Dir.UP:
				tvec.y = -16
			DirClass.Dir.DOWN:
				tvec.y = 16
			DirClass.Dir.LEFT:
				tvec.x = -16
			DirClass.Dir.RIGHT:
				tvec.x = 16
		
		target_point = global_position + tvec
		
#region state functions

#WALK state

func go_walk():
	move_state = MoveState.WALK
	turtle_anim.play("walk")

func walk_move():

	#determines how the enemy should move this frame.
	if move_state == MoveState.WALK:
		if move_index >= walk_vel_arr.size():
			move_index = 0
		if walk_dir == DirClass.Dir.UP:
			position += Vector2(0, -walk_vel_arr[move_index])
		if walk_dir == DirClass.Dir.DOWN:
			position += Vector2(0, walk_vel_arr[move_index])
		if walk_dir == DirClass.Dir.LEFT:
			position += Vector2(-walk_vel_arr[move_index], 0)
		if walk_dir == DirClass.Dir.RIGHT:
			position += Vector2(walk_vel_arr[move_index], 0)
	if move_state == MoveState.HURT:
		if hurt_dir != HurtDir.STOP:
			if move_index >= hurt_vel_arr.size():
				move_index = 0
			if walk_dir == DirClass.Dir.UP:
				position += Vector2(0, -hurt_vel_arr[move_index])
			if walk_dir == DirClass.Dir.DOWN:
				position += Vector2(0, hurt_vel_arr[move_index])
			if walk_dir == DirClass.Dir.LEFT:
				position += Vector2(-hurt_vel_arr[move_index], 0)
			if walk_dir == DirClass.Dir.RIGHT:
				position += Vector2(hurt_vel_arr[move_index], 0)
	if move_state == MoveState.SHELLED:
		#this might actually be it. its not supposed to move...
		pass
	
	#update move_index for next frame
	move_index += 1

func flip_x():
	walk_vel_arr[0] *= -1
	
func flip_y():
	walk_vel_arr[0] *= -1

#SHELLED state
func go_shell():
	move_state = MoveState.SHELLED
	turtle_anim.play("shelled")

#endregion

#region shell_triggers
func _on_shell_area_area_entered(_area):
	go_shell()

func _on_shell_area_area_exited(_area):
	walk_timer.start()

func _on_walk_timer_timeout():
	go_walk()

#endregion

#region wall triggers

func _on_up_area_entered(area):
	match move_state:
		MoveState.WALK:
			flip_y()
	
func _on_down_area_entered(area):
	match move_state:
		MoveState.WALK:
			flip_y()

func _on_left_area_entered(area):
	match move_state:
		MoveState.WALK:
			flip_x()

func _on_right_area_entered(area):
	match move_state:
		MoveState.WALK:
			flip_x()

func _on_up_body_entered(body):
	match move_state:
		MoveState.WALK:
			flip_y()

func _on_down_body_entered(body):
	match move_state:
		MoveState.WALK:
			flip_y()

func _on_left_body_entered(body):
	match move_state:
		MoveState.WALK:
			flip_x()

func _on_right_body_entered(body):
	match move_state:
		MoveState.WALK:
			flip_x()


#endregion
