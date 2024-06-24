extends Node2D

#TODO: multi directional

#seems like the timer is what gets triggered in order to trigger the actual push later
#issue is that the push timer is only activated if theres a down input. which means that the block will be touched 
#and not trigger it. i need the areas to activate the timer themselves.

#region states
enum PDir {UP, DOWN, LEFT, RIGHT}
enum MState {INITIAL, MOVING, LOCKED}
var mstate : MState = MState.INITIAL
@export var push_dir : PDir = PDir.UP

#endregion

@export var push_timer : Timer
@export var debug_name : String = "mechanisms"

#region exports
@export_group("minor parameters")
@export var snap_tol : int = 3
@export var shift_speed : int = 1
@export_group("","")

@export_group("sound effects")
@export var use_slide : bool = false
@export var slide_sfx : String = "slide_sf"
@export var use_click : bool = true
@export var click_sfx : String = "click_sf"
@export var use_solve : bool = false
@export var solve_sfx : String = "solve_sf"
@export_group("","")

#endregion

#region signals
@export_group("signals")
signal push_started						#fires when the push starts(player presses directional, or enters area while holding directional)
signal push_cancelled					#fires when the push is aborted(player releases direction)
signal block_clicked					#fires when the block snaps into place
@export_group("","")

#endregion

#region autoloads
#autoloads
@onready var sfx_pi : sfx_player = get_node("/root/sfx_player_auto")
@onready var debug_hi : debug_helper = get_node("/root/debug_helper_auto")

#endregion

var shift_prog : int = 0
var skip : bool = false
var dvec : Vector2 = Vector2(0,0)
var player_touch : bool = false :		#true if the player is touching the proper area of the block
	set(value):
		player_touch = value
		print("touchset", value)
var dir_input : String = ""

#region active functions
func _ready():
	match push_dir:
		PDir.UP:
			dir_input = "up"
			dvec = Vector2(0,-1)
		PDir.DOWN:
			dir_input = "down"
			dvec = Vector2(0,1)
		PDir.LEFT:
			dir_input = "left"
			dvec = Vector2(-1,0)
		PDir.RIGHT:
			dir_input = "right"
			dvec = Vector2(1,0)
	
func _input(event):
	if push_timer.is_stopped() && not player_touch:
		return
	if event.is_action_pressed(dir_input) && player_touch:
		debug_hi.db_message(str(event.is_action_released(dir_input)) +  " " + str(player_touch), debug_name)
		push_timer.start()
	if event.is_action_released(dir_input) || not player_touch:
		push_timer.stop()

func _physics_process(_delta):
	if mstate == MState.LOCKED:
		return
	if mstate == MState.MOVING:
		move_block()

#endregion

func begin_push():
	#this function signifies the "start" of the push.
	#the push timer should be activated.
	#it should be deactivated if the key is lifted.
	push_timer.start()

func init_move():
	mstate = MState.MOVING
	if use_slide:	sfx_pi.play_sound(slide_sfx)
	match push_dir:
		PDir.UP:
			dvec = Vector2(0, -1)
		PDir.DOWN:
			dvec = Vector2(0, 1)
		PDir.LEFT:
			dvec = Vector2(-1, 0)
		PDir.RIGHT:
			dvec = Vector2(1, 0)

func move_block():
	#skip a frame
	if skip:
		skip = false
		return
	else:
		skip = true
		
	if shift_prog >= 16:
		mstate = MState.LOCKED
		block_clicked.emit()
		if use_click:	sfx_pi.play_sound(click_sfx)
		if use_solve:	sfx_pi.play_sound(solve_sfx)
		return
	global_position += dvec
	shift_prog += 1

#region area triggers

func _on_up_area_area_entered(_area):
	if push_dir == PDir.DOWN:
		player_touch = true
		begin_push()

func _on_up_area_area_exited(_area):
	if push_dir == PDir.DOWN:
		player_touch = false

func _on_down_area_area_entered(_area):
	if push_dir == PDir.UP:
		player_touch = true
		begin_push()
		
func _on_down_area_area_exited(_area):
	if push_dir == PDir.UP:
		player_touch = false

func _on_left_area_area_entered(_area):
	if push_dir == PDir.RIGHT:
		player_touch =  true
		begin_push()

func _on_left_area_area_exited(_area):
	if push_dir == PDir.RIGHT:
		player_touch = false
		print("left exit??")

func _on_right_area_area_entered(_area):
	if push_dir == PDir.LEFT:
		player_touch = true
		begin_push()

func _on_right_area_area_exited(_area):
	if push_dir == PDir.LEFT:
		player_touch = false

func _on_push_timer_timeout():
	init_move()

#endregion
