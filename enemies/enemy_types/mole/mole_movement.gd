extends Node2D
class_name mole_movement

#this script moves the mole.
#thankfully, it should be a fairly easy script to write.
#cause it just needs to "pop up" at certain points. it doesn't really need to move or shift.
#I'm thinking that it should scatter rocks when it digs back underground. good risk/ reward.
#how should those points be decided? random? random among an array of points?
#or i could do a more real "burrowing" thing where you could see the underground trail to some extent.
#I think the array is best. i even have it burrow between those points eventually. but for now it'll just 
#disappear and warp. itd be cool if you could eventually get it with the shovel.

@export var mole_node : mole_body
@export var surface_array : Array[Node2D]
@export var mole_anim : AnimatedSprite2D

@export var under_timer : Timer
@export var up_timer : Timer
@export var surface_timer : Timer
@export var down_timer : Timer

#states:
#underground
#coming up
#up
#going down
#underground etc.

func _ready():
	under_timer.start()

func relocate():
	#TODO: reconfigure what information the mole uses to decide where to pop up.
	#TODO: would be interesting to have the popup location to be dependent on the other moles as well.
	mole_node.global_position = surface_array.pick_random().global_position

func _on_underground_timer_timeout():
	up_timer.start()
	mole_anim.play("up")
	
func _on_up_timer_timeout():
	surface_timer.start()
	mole_anim.play("surface")

func _on_surface_timer_timeout():
	down_timer.start()
	mole_anim.play("down")

func _on_down_timer_timeout():
	under_timer.start()
	mole_anim.play("under")
	relocate()
