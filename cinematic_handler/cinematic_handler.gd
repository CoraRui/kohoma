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

@export var actor_arr : Array[actor]

@export var comm_timer : Timer

@export_group("initialization")
@export var init_on_ready : bool = false
@export var use_init_area : bool
@export var init_area : Area2D
@export var use_init_timer : bool
@export var init_delay : float
@export var init_timer : Timer



var input_active : bool = false			#true when accepting player input. cin_comm can activate this in order to wait for input after a certain point.

func _ready():
	if init_on_ready:
		init_cin_comm()
	elif use_init_timer:
		init_timer.wait_time = init_delay
		init_timer.start()

func _input(event):
	#idk what input ill use
	if event.is_action_pressed("confirm") && input_active:
		next_command()

#command execution
func init_cin_comm():
	next_command()

func next_command():
	if comm_index >= comm_arr.size():
		print("commindex over commarr")
		return
	var comm : cin_comm = comm_arr[comm_index]
	if comm.move_actor:
		move_actor(comm)
	if comm.animate_actor:
		animate_actor(comm)
	if comm.jump_to_index:
		comm_index = comm.jump_index - 1
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
	for a in actor_arr:
		if a.actor_name == comm.anim_actor_name:
			print("attemped")
			a.actor_anim.play(comm.anim_name)

func _on_init_timer_timeout():
	#this timer activates on ready, using a brief delay to initialize the commands.
	init_cin_comm()

func _on_init_area_area_entered(area):
	#initialized the commands if a valid area enters
	init_cin_comm()
	
func _on_init_area_body_entered(body):
	init_cin_comm()

func _on_comm_timer_timeout():
	#should activate next command
	next_command()
