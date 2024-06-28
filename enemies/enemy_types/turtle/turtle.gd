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
var move_state : MoveState = MoveState.WALK :
	get: 
		return move_state
	set(v):
		if v != MoveState.SHELLED:
			hp_script.temp_inv = false
		move_state = v

#region exports

@export_group("animation")
@export var turtle_anim : AnimatedSprite2D
@export_group("","")

#each frame, the move_frame function uses one index from the vel_arr for the current movement state to 
#determine how far to move the enemy.
@export_group("movement")
@export var snap_tol : int = 3
@export var walk_timer : Timer 			#delay before starting to walk after player leaves shell area
@export var rand_timer : Timer			#timer between random directional changes.
@export var pot_ins : pot 				#allows turtle to be picked up while shelled
@export_group("","")

#endregion

@export var hp_script : enemy_health
@export var spike_ins : spike

#autoloads
@onready var debug_hi : debug_helper = get_node("/root/debug_helper_auto")

#movement variables
@export var mvec_arr : Array[Vector2] = [Vector2(0,0), Vector2(0,0)] 
var move_index : int = 0 #tracks which frame in the movement pattern to use.


func _ready():
	rand_dir()

func _physics_process(_delta):
	find_state()

func find_state():
	match move_state:
		MoveState.WALK:
			walk_move()
		MoveState.SHELLED:
			pass

func rand_dir():
	#switches the direction of the turtles walk state to a random direction
	var up : int = 25
	var down : int = 25
	var left : int = 25
	var right : int = 25
	
	var r : int = randi_range(0, up+down+left+right)
	
	r -= up
	if r < 0:
		mvec_arr[0] = Vector2(0,-1)
		r += 1000
	r -= down
	if r < 0:
		mvec_arr[0] = Vector2(0,1)
		r += 1000
	r-= left
	if r < 0:
		mvec_arr[0] = Vector2(-1,0)
		r += 1000
	r -= right
	if r < 0:
		mvec_arr[0] = Vector2(1,0)
		r += 1000
	
func flip_y():
	mvec_arr[0].y *= -1
	
func flip_x():
	mvec_arr[0].x *= -1

#region state functions

#WALK state

func go_walk():
	move_state = MoveState.WALK
	turtle_anim.play("walk")
	rand_dir()
	pot_ins.toggle_pot(false)
	spike_ins.toggle_spike(true)

func walk_move():
#Im going to change this from being a target point.
#instead, it will use a Array[Vector2] and index
	global_position += mvec_arr[move_index]
	move_index += 1
	if move_index >= mvec_arr.size():
		move_index = 0
	
#SHELLED state
func go_shell():
	move_state = MoveState.SHELLED
	turtle_anim.play("shelled")
	hp_script.temp_inv = true
	pot_ins.toggle_pot(true)
	spike_ins.toggle_spike(false)
	
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

func _on_up_area_entered(_area):
	match move_state:
		MoveState.WALK:
			flip_y()
	
func _on_down_area_entered(_area):
	match move_state:
		MoveState.WALK:
			flip_y()

func _on_left_area_entered(_area):
	match move_state:
		MoveState.WALK:
			flip_x()

func _on_right_area_entered(_area):
	match move_state:
		MoveState.WALK:
			flip_x()

func _on_up_body_entered(_body):
	match move_state:
		MoveState.WALK:
			flip_y()

func _on_down_body_entered(_body):
	match move_state:
		MoveState.WALK:
			flip_y()

func _on_left_body_entered(_body):
	match move_state:
		MoveState.WALK:
			flip_x()

func _on_right_body_entered(_body):
	match move_state:
		MoveState.WALK:
			flip_x()

#endregion

func _on_rand_timer_timeout():
	match move_state:
		MoveState.WALK:
			rand_dir()
			debug_helper.db_message("turtle random", "enemies")
