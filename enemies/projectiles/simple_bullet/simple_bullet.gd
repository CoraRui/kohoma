extends Node2D

#should just travel according to the vector array as soon as its instantiated.
#at least for now. i think itd be helpful to do phases where it travels at different speeds.
#whichever script instantiates it should just set the vec arr and let it go. 

#script for creating simple bullets

@export var vec_arr : Array[Vector2]

@export var exp_timer : Timer

var vec_index : int = 0

func _physics_process(delta):
	move()
	
func move():
	position += vec_arr[vec_index]
	if vec_index >= vec_arr.size():
		vec_index = 0

func collide():
	#does any necessary functions when colliding with an object. like searching that object for health scripts/unique sfx etc.
	end()
	
func end():
	#does any functions needed when getting rid of the rock
	queue_free()

func _on_exp_timer_timeout():
	end()
