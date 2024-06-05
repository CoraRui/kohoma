extends Node2D


#mostly added this cause I eventually want to test the fishing rod 

#amount of time to pull on switch until it flips
@export var pull_timer : Timer




func flip():
	print("*click*")

func _on_hook_module_pull():
	pull_timer.start()

func _on_hook_module_relax():
	pull_timer.stop()

func _on_pull_timer_timeout():
	flip()
