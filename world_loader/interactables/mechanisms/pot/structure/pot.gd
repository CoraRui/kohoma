extends Node2D
class_name pot

#its called pot but its just for lifting things
#think about the way that the input should work too.

#region exports

@export_group("enumerators")
enum MoveState { IDLE, THROW }
var move_state : MoveState = MoveState.IDLE
#when you pull on this object, what happens?
#does it drag on the floor? does it lift? does it only lift if you have the 
#strong lift upgrade? 
enum PullType {PULL, HEAVY_PULL, LIFT, HEAVY_LIFT, STATIC}
@export var pull_type : PullType = PullType.STATIC
@export var pot_active : bool = true
@export_group("","")

@export_group("node refs")
@export var pot_target : Node2D		#target for positional translation with the player and throwing movement. usually parent
@export var lift_point : Node2D		#spot the player will be moved to when lifting/grabbing the pot if applicable
									#possibly only bind to an axis if its like a wall or something.
@export var hold_point : Node2D		#spot used to hold the pot
@export var wall_ref : fourdwall
@export_group("","")

@export_group("sfx")
#unique sfx for the pot. ill try to have a default set though.
#booleans determine whether to use custom or default
@export var use_grab_sf : bool = false
@export var grab_sf : sf_link
@export var use_throw_sf : bool = false
@export var throw_sf : sf_link
@export_group("","")

#throw_info
var tvec : Vector2 = Vector2(0,0)		#vector used to determine movement for the thrown state
@export var throw_vel : int = 1
@export var fall_vel_arr : Array[int] = [-1,-1]		#array holding pixels moved per frame for the throw state.
var fall_arr_index : int = 0

#endregion

#region signals

signal grabbed		#when the player first grabs the pot
signal pulled		#when the player uses the directional arrow opposite the pot
signal lifted		#when the player pulls on the pot successfully lifting it
signal thrown		#when the player throws the pot after lifting it.
signal landed		#when the pot lands on the ground

#endregion

func _physics_process(_delta):
	move_state_matrix()

func move_state_matrix() -> void:
	match move_state:
		MoveState.THROW:
			throw_frame()

func throw_frame():
	pot_target.global_position += Vector2(tvec.x, tvec.y - fall_vel_arr[fall_arr_index])
	fall_arr_index += 1
	if fall_arr_index >= fall_vel_arr.size():
		move_state = MoveState.IDLE
		fall_arr_index = 0

func collision_check() -> void:
	#im trying to think of how to check for them.
	#like depending on the state, what do i want? and when/where do I put this?
	#it should somehow be between the calculation of movement and the actual movement
	#so does that mean that i should separate the movement calculation and actual movement and 
	#do collision checks inbetween? then make the collision checks state driven to have unique collsion
	#operations for each state?????? cause i dont want collisions for the idle state. 
	
	#identify the move_state and perform appropriate collision checks
	match move_state:
		MoveState.THROW:
			pass

func throw_collision():
	#collision for throw state. should just stop the velocity in the proper direction
	#so just check for bodies in the top or bottom areas, then freeze the velocity in that direction.
	#it might be weird if it collides with top cause theres the "fall" thing. but honestly i think just stopping
	#it will look fine
	if wall_ref.area_arr[0]:
		pass
	
	

func throw(d : DirClass.Dir) -> void:
	#this function starts the throw movement for the pot.
	#thinking of different throw types. but later not now!!!
	#this should just move the object in a thrown fashion until it stops and goes back to being idle.
	#probably just on a timer with some sort of initial velocity and an acceleration on y
	
	#change state to throw 
	move_state = MoveState.THROW
	
	#determine initial velocity
	tvec = DirClass.get_uvec(d)
	
	tvec.x *= throw_vel
	
func toggle_pot(b : bool) -> void:
	pot_active = b
	

#4dwall signals
#i don't think its a big deal but setting up collision is gonna be annoying
#just make is disableable and it wont be a big deal worst case
#and check for body/area being null. but its not a big deal if you don't have to use them.
#which usually you dont.

#wait maybe i dont need these. i think i usually check for each wall in the movement script.
#so i dont need the signals? cause if i use signals it only does it on enter. it should be a part of the 
#process check. dumbass. although im sure the signals could be useful for. something? but not now.

