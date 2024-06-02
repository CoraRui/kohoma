extends Node2D
class_name fishing_rod

#TODO: create actual actoin of the rod
#TODO: activation/deactivation of other things, like pausing player movement and the other item
#TODO: icon in the item select menu. or just text for now i suppose...

#this script handles everything about the fishing rod.

#enums
enum ActiveState {ACTIVE, INACTIVE}
var active_state : ActiveState = ActiveState.INACTIVE

#states that define how the bobber moves and affects other objects.
#I'm wondering how this will handle what the bobber gets caught on.
#for instance, when the bobber lands, it can either:
#get caught on an enemy
#land on the ground
#be in water
#do I want different states for each of those things?
#or does rest describe that?
#anyways, I'll just design it to fall on the ground then rest for now.
#I'll define different types of motion and reactivity later.
enum ActionState {REELED, CHARGE, THROW, REST, PULL}
var action_state : ActionState = ActionState.REELED

#the longer the player holds the charge button, the more the charge increases.
#there'll probably be some kind of tone to alert the player "how charged" it is.
# also possibly a series of animations to gauge it
#either a series of tones indicated approximated charge value
#for now, just hold the button, then 
#value between 1-90 representing how charged the rod is.(cause 90 frames is a second and a half)
var charge_meter : float = 0

@export var cpf : float = 1

func _physics_process(_delta):
	if ActionState.CHARGE:
		charge_meter += cpf


func _input(event):
	if active_state == ActiveState.ACTIVE:
		
		#reeled means that the fishing rod has just been pulled out, and the line is reeled in
		if action_state == ActionState.REELED:
			if event.is_action_pressed("attack"):
				#start charging
				action_state = ActionState.CHARGE
		
		#charge means that the rod is lifted, and the player is about to cast
		if action_state == ActionState.CHARGE:
			if event.is_action_released("attack"):
				cast()
		
		#throw means that the rod has just been cast, and the bobber is flying through the air.
		#I think that the next state change will be triggered by the bobber.
		#it'll probably be connected to this script on instantiation.
		if action_state == ActionState.THROW:
			pass
		
		#rest means that the bobber is on the ground
		if action_state == ActionState.REST:
			pass
		
		#means that the player is pulling on the line?
		#hm. i think this might be weird.
		if action_state == ActionState.PULL:
			pass


func activate_rod():
	#this should activate the rods functions and disable certain player movement actions, and probably the inventory menu
	print("rod activated! ... not really")

func cast():
	#should essentially just instantiate the bobber. the bobber script will probably take care of whatever else it has to do?
	#this function happens once the charge phase is over.
	charge_meter = 0
	pass

func release():
	#releases any caught thing and returns to reeled state.
	pass

func pull():
	pass

func reel_in():
	#attempts to reel in the bobber, has different effects depending on if its caught on something, at rest, if its near the player enough to return, etc.
	pass
