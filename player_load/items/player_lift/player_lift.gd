extends Node2D
class_name player_lift

#TODO: should I have return values for functions that can fail/succeed? what would I use them for
#TODO: throw pot in other situations, like when hurt
#TODO: how to get directional information?
#TODO: when to disable input for player_lift
#TODO: which things need to be relocated when the player turns? (grab_area, throw_direction, hold_point stays)
#TODO: disable other functions on player lift

#ok. so the player approaches the pot.
#they grab it
#they pull it.
#they lift it after pulling for a moment
#they hold it after finishing lifting
#they can put it down, or throw it.
#should I allow putting down? or only throwing?
#I don't think it would hurt to allow putting down.
#

enum LiftState {IDLE, GRAB, PULL, LIFT, HOLD, THROW}
#IDLE - player is not grabbing.
#GRAB - player has pressed and held confirm on a pot
#PULL - player is pulling in the opposite direction while grabbing
#LIFT - player held pull long enough to pick up the pot
#HOLD - player is carrying the object
#THROW - player is throwing the object. the object may have already left, this is more like a recoil state.
var lift_state : LiftState = LiftState.IDLE

#need a directional enum to indicated the direction the player is facing.
#use it for relocating the grab point, drop_point, throw direction, etc.
var grab_dir : DirClass.Dir = DirClass.Dir.NONE

#going to be an area that looks for objects of type pot.
#then lifts them over the players head, and can throw them.


#region exports

@export_group("points")
@export var grab_area : Area2D
@export var hold_point : Node2D
@export var drop_point : Node2D
@export var grab_arr : Array[Node2D]		#points that the grab area should be relocated to on turn, udlr
@export var drop_arr : Array[Node2D]		#points that the drop point can be relocated to.
@export_group("","")

@export var throw_timer : Timer				#how long the players throw state lasts before returning to idle
@export var lift_timer : Timer
@export var pull_timer : Timer				#default delay for pulling an object before lifting it.

@export_group("sfx")
@export var grab_sf : sf_link
@export var throw_sf : sf_link
@export_group("","")

#endregion

var pot_ins : pot 							#reference to pot currently being carried

#region autoloads

@onready var debug_hi : debug_helper = get_node("/root/debug_helper_auto")
@onready var player_li : player_loader = get_node("/root/player_loader_auto")
@onready var sfx_pi : sfx_player = get_node("/root/sfx_player_auto")

#endregion

#region signal instances
signal grab_signal
signal pull_signal
signal lift_signal
signal hold_signal
signal throw_signal
signal release_signal

#endregion

func _physics_process(_delta):

	move_pot()

#region input handling

func _input(event):
	confirm_input(event)
	attack_input(event)
	dir_input(event)
	player_li.player_ins.anim_script.animate_pot(lift_state)		#TODO: relocate this to a more efficient spot, or spots. honestly not a big deal.
	
func confirm_input(e : InputEvent) -> void:

	if e.is_action_pressed("confirm"):
		match lift_state:
			LiftState.IDLE:
				try_grab()
			LiftState.GRAB:
				pass
			LiftState.PULL:
				debug_helper.db_message("player lift pressed confirm while in pull state. shouldn't be possible.", "player")
			LiftState.LIFT:
				debug_helper.db_message("player lift pressed confirm while in lift state. shouldn't be possible.", "player")
			LiftState.HOLD:
				try_release()
			LiftState.THROW:
				pass
			
	if e.is_action_released("confirm"):
		match lift_state:
			LiftState.IDLE:
				debug_helper.db_message("player lift released confirm while in idle state. shouldn't be possible.", "player")
			LiftState.GRAB:
				let_go()
			LiftState.PULL:
				try_release()
			LiftState.LIFT:
				pass		#dont think this should do anything. lifting is committed once started.
			LiftState.HOLD:
				pass		#attempts to put the item down in front of the player.
			LiftState.THROW:
				pass		#does nothing

func attack_input(e : InputEvent) -> void:
	if e.is_action_pressed("attack"):
		match lift_state:
			LiftState.HOLD:
				try_throw()
				
	if e.is_action_released("attack"):
		match lift_state:
			LiftState.IDLE:
				pass		#just put here as placeholder

func dir_input(e : InputEvent) -> void:
	match lift_state:
		LiftState.IDLE:
			turn(e)
		LiftState.HOLD:
			turn(e)
		LiftState.GRAB:
			if DirClass.input_to_dir(e) != DirClass.Dir.NONE:
				try_pull(e)
	

#endregion

func move_pot() -> void:
	if !pot_ins || lift_state != LiftState.HOLD:
		return
	pot_ins.pot_target.global_position = hold_point.global_position - (pot_ins.hold_point.global_position - pot_ins.pot_target.global_position)

func turn(e : InputEvent):
	#changes enumerator state on directional movement input while in idle state.
	if DirClass.input_to_dir(e) != DirClass.Dir.NONE:
		grab_dir = DirClass.input_to_dir(e)
		grab_area.global_position = grab_arr[DirClass.dir_to_udlr(DirClass.input_to_dir(e))].global_position
		drop_point.global_position = drop_arr[DirClass.dir_to_udlr(DirClass.input_to_dir(e))].global_position
	
#region actions

func try_grab() -> void:
	debug_helper.db_message("tried to grab", "lift")
	#attempts to find an object and grab it.
	if grab_area.has_overlapping_bodies():
		for b in grab_area.get_overlapping_bodies():
			if b.get_parent() is pot:
				grab(b.get_parent())
			
	if grab_area.has_overlapping_areas():
		for a in grab_area.get_overlapping_areas():
			if a.get_parent() is pot:
				grab(a.get_parent())

func grab(p : pot) -> void:
	lift_state = LiftState.GRAB
	grab_signal.emit()
	pot_ins = p
	player_li.player_ins.set_sword_active(false)
	player_li.player_ins.set_movement(false)


	#play sfx (use the pots custom sound link if desired)
	if p.use_grab_sf:	sfx_pi.play_sound_link(p.grab_sf)
	else:	sfx_pi.play_sound_link(grab_sf)

	debug_helper.db_message("grabbing", "lift")

func let_go() -> void:
	#lets go of a grabbed object
	debug_helper.db_message("let go", "lift")
	lift_state = LiftState.IDLE
	pot_ins = null
	player_li.player_ins.set_movement(true)
	player_li.player_ins.set_sword_active(true)

func try_pull(e : InputEvent) -> void:
	debug_helper.db_message("tried to pull", "lift")
	print("directions", DirClass.input_to_dir(e), grab_dir)
	if DirClass.are_opposite(DirClass.input_to_dir(e), grab_dir):
		pull()
	
func pull() -> void:
	#when pulling, im not gonna use a lift timer. there might be a temporary state while the lift animation plays, but no timer
	#if the player is grabbing something it can lift, it will do that
	#if grabbing something it can pull it pulls
	#if its stationary, they strain. just an animation.
	debug_helper.db_message("pulled pot", "lift")
	
	match pot_ins.pull_type:
		pot.PullType.STATIC:
			pass
		pot.PullType.PULL:
			pass
		pot.PullType.HEAVY_PULL:
			pass
		pot.PullType.LIFT:
			try_lift()
		pot.PullType.HEAVY_LIFT:
			#where is heavy lift mod stored?
			pass
	
func try_lift() -> void:
	#attempts to lift the grabbed object
	lift(pot_ins)

func lift(p : pot) -> void:
	#moves pot to hold point. 
	#TODO: fix to move to hold point gradually, right now it just warps it.
	lift_state = LiftState.HOLD
	player_li.player_ins.set_movement(true)
	player_li.player_ins.set_sword_active(false)

func try_throw() -> void:
	if !pot_ins:
		return
	
	throw()

func throw() -> void:
	#remove the pot_ins reference, and trigger the throw movement in the pot.
	pot_ins.throw()
	lift_state = LiftState.THROW
	#timer for back to idle state
	throw_timer.start()
	
	#play sfx
	if pot_ins.use_throw_sf:	sfx_pi.play_sound_link(pot_ins.throw_sf)
	else:	sfx_pi.play_sound_link(throw_sf)
	
	pot_ins = null

func try_release() -> void:
	if !pot_ins:
		return
	debug_helper.db_message("released pot", "lift")
	release()
	
func release() -> void:
	lift_state = LiftState.IDLE
	release_signal.emit()
	pot_ins.pot_target.global_position = drop_point.global_position
	pot_ins = null

func try_put_down() -> void:
	pass
	
func put_down() -> void:
	pass

#endregion

#region in signals

func _on_throw_timer_timeout():
	lift_state = LiftState.IDLE
	player_li.player_ins.anim_script.switch_anim_state(player_anim.AnimState.MOVE)
	
#endregion
