extends Node2D

#I can figure out bullet point later if I need to. for now, just set it at the center of the octo.
#direction of travel determined by the. hm. should I have a ref to movement? yeah probably...
#launches a boulder at random intervals. should have signals to connect to other scripts to change their behaviour

@export var enemy_ref : octo
@export var delay_timer : Timer

@export_group("boulder_parameters")
@export var rock_ref : PackedScene
@export var burst_delay : float = 3.0	#avg amt of time between each burst
@export var burst_var : float = 2		#total randomized deviance or burst delay between each burst
@export var shot_count : int = 1 		#how many boulders to fire in one burst
@export var shot_delay : float = 0.3	#time between each shot in a burst
@export_group("","")




func fire():
	var new_rock : simple_bullet = rock_ref.instantiate()
	get_tree().get_root().add_child(new_rock)
	new_rock.vec_arr[0] = DirClass.get_uvec(enemy_ref.movement.octo_dir)
	
func calc_delay() -> float:
	var new_wait : float = burst_delay
	new_wait += burst_var * randf_range(0,1)
	return new_wait


	
func _on_delay_timer_timeout():
	fire()
	delay_timer.wait_time = calc_delay()
	delay_timer.start()
