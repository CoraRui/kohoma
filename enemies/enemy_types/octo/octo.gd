extends Node2D
class_name octo

#TODO: finish exposing variables
#TODO: adjust knockback to not go into wallss
#I want to expose more variables here so that its more customizable without exposing children in editor.

@export var movement : octo_movement
@export var mvec_arr : Array[Vector2]
@export var stun_time : float = -1
@export var hurt_time : float = -1
@export var kb_vel : int = -1

func _ready():
	if mvec_arr:
		movement.mvec = mvec_arr
	if stun_time != -1:
		movement.stun_timer.wait_time = stun_time
	if hurt_time != -1:
		movement.hurt_timer.wait_time = hurt_time
	
