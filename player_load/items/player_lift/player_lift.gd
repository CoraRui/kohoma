extends Node2D
class_name player_lift

#TODO: should I have return values for functions that can fail/succeed? what would I use them for
#TODO: throw pot in other situations, like when hurt
#TODO: how to get directional information?
#TODO: when to disable input for player_lift
#TODO: which things need to be relocated when the player turns? (grab_area, throw_direction, hold_point stays)

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

var grab_dir : DirClass.Dir = DirClass.Dir.NONE

#going to be an area that looks for objects of type pot.
#then lifts them over the players head, and can throw them.

@export var grab_area : Area2D

@export var hold_point : Node2D

@export var grab_arr : Array[Node2D]		#points that the grab area should be relocated to on turn, udlr

#region autoloads

#autoloads
@onready var debug_hi : debug_helper = get_node("/root/debug_helper_auto")
@onready var player_li : player_loader = get_node("/root/player_loader_auto")

#endregion

#region signals
signal grab_signal
signal pull_signal
signal lift_signal
signal hold_signal
signal throw_signal
signal release_signal

#endregion

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
				debug_hi.db_message("player lift pressed confirm while in grab state. shouldn't be possible.", "player")
			LiftState.PULL:
				debug_hi.db_message("player lift pressed confirm while in pull state. shouldn't be possible.", "player")
			LiftState.LIFT:
				debug_hi.db_message("player lift pressed confirm while in lift state. shouldn't be possible.", "player")
			LiftState.HOLD:
				try_put_down()
			LiftState.THROW:
				pass
			
	if e.is_action_released("confirm"):
		match lift_state:
			LiftState.IDLE:
				debug_hi.db_message("player lift released confirm while in idle state. shouldn't be possible.", "player")
			LiftState.GRAB:
				try_release()
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
				
	if e.is_action_released("confirm"):
		match lift_state:
			LiftState.IDLE:
				pass		#just put here as placeholder

func dir_input(e : InputEvent) ->void:
	#use last pressed direction?
	match lift_state:
		LiftState.IDLE:
			match e.is_action_pressed("up"):
				DirClass.Dir.UP:
					pass

#region actions
func try_grab() -> void:
	#attempts to find an object and grab it.
	if grab_area.has_overlapping_bodies():
		for b in grab_area.get_overlapping_bodies():
			for c in b.get_parent().get_children():
				grab(c)
			
	if grab_area.has_overlapping_areas():
		for a in grab_area.get_overlapping_areas():
			for c in a.get_parent().get_children():
				if c is pot:
					grab(c)

func grab(p : pot):
	lift_state = LiftState.GRAB
	grab_signal.emit()
	#how does the pot move on top of the player? straight line to hold point
	
func try_pull() -> void:
	pass
	
func pull() -> void:
	pass
	
func try_lift() -> void:
	#attempts to lift the grabbed object
	pass

func lift() -> void:
	pass

func try_throw() -> void:
	pass

func throw() -> void:
	pass

func try_release() -> void:
	release()
	
func release() -> void:
	lift_state = LiftState.IDLE
	release_signal.emit()

func try_put_down() -> void:
	pass
	
func put_down() -> void:
	pass

#endregion
