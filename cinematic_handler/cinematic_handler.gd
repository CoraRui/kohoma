extends Node2D


#this script and node should handle "cinematics"
#basically any event that locks the players movement and has lots of dialogue and 
#character blocking and stuff.

#It should: 
#lock player movement
#allow for dialogue box
#allow blocking
#have a string of commands that do these things which I can change order of


@export var comm_arr : Array[cin_comm]
@export var comm_index : int = 0

@export var actors : Array[actor]

@export var comm_timer : Timer

var input_active : bool = false			#true when accepting player input. cin_comm can activate this in order to wait for input after a certain point.

func _input(event):
	#idk what input ill use
	if event.is_action_pressed("advance_cinematic") && input_active:
		next_command()

func init_cin_comm():
	next_command()

#this is the main function that processes each command.
func next_command():
	var comm : cin_comm = comm_arr[comm_index]
	if comm.move_actor:
		move_actor(comm)
	if comm.animate_actor:
		animate_actor(comm)
	if comm.advance_immediately:
		comm_index += 1
		next_command()
	elif comm.advance_timer:
		comm_index += 1
		comm_timer.wait_time = comm.advance_delay
		comm_timer.start()
	elif comm.advance_input:
		pass
		
func move_actor(comm : cin_comm):
	print("started moving actor")

func display_dialogue(comm : cin_comm):
	print("started displaying dialogue")

func animate_actor(comm : cin_comm):
	print("started actor anim")






