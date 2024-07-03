extends Node2D
class_name boomerang

#the boomerang should travel in a straight line from where thrown, then return to the player
#following a simple return movement pattern

#TODO: protocol for more than one catch at a time
#TODO: clear boomerang on level load
#TODO: make hitting stuff actually doing stuff. that might not even mean doing anything in this script.
#you might have to program all of the other scripts to do stuff manually. like each enemy, each thing that
#can recieve some sort of hit. like switches and stuff.

#how do i have things be caught by the boomerang?
#boomerang script looks for a certain node type or collider
#new node type looks for boomerang and attaches itself to it.
#i think using the boomerang to find a new type would be best
#i can use that new type to connect with signals in that object to things that need to change
#when the object is caught/released etc.


enum FlyState {THROW, HANG, RETURN}

var fly_state : FlyState = FlyState.THROW

@export var tvel : Vector2 = Vector2(0,0)
@export var vel_mod : int = 2
@export var rvel : Vector2 = Vector2(0,0)

@export var axis_tol : int = 3

@export var throw_timer : Timer #timer for the initial throw path
@export var hang_timer : Timer	#timer for hang
@export var exp_timer : Timer	#timer that returns the boomerang if it doesn't return for some reason

#signals
signal caught_boomerang
signal threw_boomerang


#autoloads
@onready var player_li : player_loader = get_node("/root/player_loader_auto")

func _ready():
	threw_boomerang.emit()
	tvel = DirClass.get_uvec(player_li.player_ins.direction) * vel_mod
	throw_timer.start()
	
func _process(_delta):
	
	match fly_state:
		FlyState.THROW:
			throw_move()
		FlyState.RETURN:
			return_move()
		
func throw_move():
	position += tvel

func return_move():
	position += rvel
	if abs(global_position.x - player_li.player_ins.global_position.x) < axis_tol:
		rvel.x = 0
	else:
		rvel.x = -1 * sign(global_position.x - player_li.player_ins.global_position.x) * vel_mod
		
	if abs(global_position.y - player_li.player_ins.global_position.y) < axis_tol:
		rvel.y = 0
	else:
		rvel.y = -1 * sign(global_position.y - player_li.player_ins.global_position.y) * vel_mod
		
	if rvel == Vector2(0,0):
		catch()

func catch():
	debug_helper.db_message("caught boomerang","items")
	caught_boomerang.emit()
	queue_free()

func _on_throw_timer_timeout():
	fly_state = FlyState.HANG
	hang_timer.start()

func _on_hang_timer_timeout():
	#TODO: make a separate function for this. probably along the lines of "init_return" and switch the catch point signal as well.
	fly_state = FlyState.RETURN
	rvel = global_position.direction_to(player_li.player_ins.global_position)
	if rvel.x != 0:
		rvel.x = rvel.x/abs(rvel.x)
	if rvel.y != 0:
		rvel.y = rvel.y/abs(rvel.y)
	rvel *= vel_mod
	
func _on_exp_timer_timeout():
	catch()
