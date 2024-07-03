extends Node2D
class_name catch_object


#this node should be able to attach to objects that need to be carried by the boomerang.

#how does the object move once its caught?

#catch node latches onto the target object

signal caught
signal released

enum CatchState { FREE, CAUGHT, RELEASED}
var catch_state : CatchState = CatchState.FREE

@export var catch_target : Node2D				#node that should be followed

@export var catch_node : Node2D					#node to be moved

@export var catch_area : Area2D					#area that is made contact with in order for the object to be caught

@export var catch_anim : AnimatedSprite2D		#animated sprite that may change on being caught

@export var caught_anim_name : String

@export var released_anim_name : String 		#animation to be played when object is released


#on release events
@export var use_pot : bool = false				#uses the pot reference to give the catchable to the player to hold on release if true
@export var pot_ref : pot						#holds a pot script to give to the player

#autoloads
@onready var player_li : player_loader = get_node("/root/player_loader_auto")

func _physics_process(_delta):
	move_state_matrix()

func move_state_matrix():
	match catch_state:
		CatchState.CAUGHT:
			move()

func move() -> void:
	if !catch_target:
		#temporary fix for the after the boomerang is caught. though i think it works fine lol
		release()
		return
	catch_node.global_position = catch_target.global_position

func catch(a : Area2D) -> void:
	#normally will be triggered by a signal from the catch area. should also disable the catch area while caught, 
	#or add state thing in signal.
	#issue. how do i know exactly which point to use?
	#there needs to be some data type that this node looks for.
	#ill need some sort of catch_point in objects that can catch things.
	#like the boomerang will have a catch point as a sibling in its children.
	#then that will contain the ref point/other things for interacting with the catch node
	
	for s in a.get_parent().get_children():
		if s is catch_point:
			catch_target = s.catch_target
			s.caught.emit()
			s.released.connect(release_signal)
	
	if !catch_target:
		catch_target = a
	
	catch_state = CatchState.CAUGHT
	
func release() -> void:
	#take appropriate action for catchable object on release
	catch_state = CatchState.RELEASED
	
	#give attached pot to player lift script
	if use_pot && pot_ref:
		player_li.player_ins.lift_script.grab(pot_ref)
		player_li.player_ins.lift_script.lift(pot_ref)

#signals
func release_signal() -> void:
	#this function is connected to the catch point's release signal. that signal will be triggered by the 
	#boomerang when it it caught, or whatever other signal/function you'd like the catch objects release to be triggered by.
	print("release signal")
	released.emit()
	release()

func _on_catch_area_area_entered(area):
	match catch_state:
		CatchState.FREE:
			catch(area)
		CatchState.RELEASED:
			catch(area)

func _on_bomb_clear_signal():
	#from bombs clear signal. should release the bomb from player lift on execution.
	player_li.player_ins.lift_script.try_release()
