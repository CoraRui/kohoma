extends Node2D
class_name shut_door

#this script should contain functions for doors that open and close.
#essentially just some wall that becomes active/inactive and has some animation associated with it.

#should stay open if the player is in its space.

#issue, what about different types of doors/ animations?
#i could just do an edit children thing. would that let me change the animations?
#i think so. then i could just put different sprites into the open/close animations
#ill have to be able to edit the area anyways.
#ugh ok you cant change it.
#ok ill have a bunch of available animations to use then have an exported string that indicates which to use.

@export var door_anim : AnimatedSprite2D
@export var door_area : Area2D
@export var door_open_anim : String  = "open"
@export var door_closed_anim : String = "closed"

#internals
var is_open : bool = true

func toggle_door_open(b : bool) -> void:
	#opens or shuts the door. doesn't do anything if already open.
	
	if b == is_open:
		return	#checks if toggle is unnecessary
	
	if b:
		is_open = b
		door_anim.play(door_open_anim)
		door_area.get_child(0).set_deferred("disabled", true)
	else:
		is_open = b
		door_anim.play(door_closed_anim)
		door_area.get_child(0).set_deferred("disabled", false)
	

#temporary door shut on boss start.
func _on_boss_init_area_area_entered(_area):
	toggle_door_open(false)
